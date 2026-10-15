#!/usr/bin/env python3
"""Dev-only: render Quiet Steps spoken lines with Piper TTS.

Downloads Piper voices into ~/.cache/piper-voices (not committed).
Writes mono Opus clips to assets/voices/<lang>/<female|male>/<id>.ogg.

Usage (from the project root):
    python tool/render_voices.py
    python tool/render_voices.py --force
    python tool/render_voices.py --dump
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile
import time
import wave
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LIB = ROOT / "lib" / "l10n"
OUT = ROOT / "assets" / "voices"
CACHE = Path.home() / ".cache" / "piper-voices"
HF = "https://huggingface.co/rhasspy/piper-voices/resolve/main"

LANGS = ("en", "sk", "cs", "pl", "de", "es", "fr", "it")
VOICES = ("female", "male")

# (relative onnx stem without extension, speaker_id or None)
VOICE_MODELS = {
    ("en", "female"): ("en/en_GB/cori/high/en_GB-cori-high", None),
    ("en", "male"): ("en/en_US/norman/medium/en_US-norman-medium", None),
    ("sk", "female"): ("sk/sk_SK/lili/medium/sk_SK-lili-medium", None),
    ("sk", "male"): ("cs/cs_CZ/jirka/medium/cs_CZ-jirka-medium", None),
    ("cs", "female"): ("cs/cs_CZ/kasandra/medium/cs_CZ-kasandra-medium", None),
    ("cs", "male"): ("cs/cs_CZ/jirka/medium/cs_CZ-jirka-medium", None),
    ("pl", "female"): ("pl/pl_PL/gosia/medium/pl_PL-gosia-medium", None),
    ("pl", "male"): ("pl/pl_PL/darkman/medium/pl_PL-darkman-medium", None),
    ("de", "female"): ("de/de_DE/ramona/low/de_DE-ramona-low", None),
    ("de", "male"): ("de/de_DE/thorsten/high/de_DE-thorsten-high", None),
    ("es", "female"): ("es/es_ES/sharvard/medium/es_ES-sharvard-medium", 1),
    ("es", "male"): ("es/es_ES/davefx/medium/es_ES-davefx-medium", None),
    ("fr", "female"): ("fr/fr_FR/siwis/medium/fr_FR-siwis-medium", None),
    ("fr", "male"): ("fr/fr_FR/upmc/medium/fr_FR-upmc-medium", 1),
    ("it", "female"): ("it/it_IT/paola/medium/it_IT-paola-medium", None),
    ("it", "male"): ("it/it_IT/riccardo/x_low/it_IT-riccardo-x_low", None),
}

VOICE_SAMPLE = {
    "en": "This is the Quiet Steps voice.",
    "sk": "Toto je hlas Quiet Steps.",
    "cs": "Toto je hlas Quiet Steps.",
    "pl": "To jest głos Quiet Steps.",
    "de": "Das ist die Stimme von Quiet Steps.",
    "es": "Esta es la voz de Quiet Steps.",
    "fr": "Voici la voix de Quiet Steps.",
    "it": "Questa è la voce di Quiet Steps.",
}

UA = "QuietStepsVoiceRenderer/1.0 (dev; piper-tts)"


class DartParser:
    def __init__(self, text: str):
        self.text = text
        self.i = 0
        self.n = len(text)

    def skip(self) -> None:
        t = self.text
        i = self.i
        n = self.n
        while i < n:
            c = t[i]
            if c in " \t\r\n":
                i += 1
                continue
            if c == "/" and i + 1 < n and t[i + 1] == "/":
                i += 2
                while i < n and t[i] not in "\r\n":
                    i += 1
                continue
            if c == "/" and i + 1 < n and t[i + 1] == "*":
                i += 2
                while i + 1 < n and not (t[i] == "*" and t[i + 1] == "/"):
                    i += 1
                i = min(n, i + 2)
                continue
            break
        self.i = i

    def peek(self) -> str:
        self.skip()
        return self.text[self.i] if self.i < self.n else ""

    def parse_string(self) -> str:
        self.skip()
        q = self.text[self.i]
        if q not in "'\"":
            raise ValueError(f"expected string at {self.i}")
        self.i += 1
        out: list[str] = []
        t = self.text
        while self.i < self.n:
            c = t[self.i]
            if c == "\\":
                nxt = t[self.i + 1]
                mapping = {
                    "n": "\n",
                    "r": "\r",
                    "t": "\t",
                    "'": "'",
                    '"': '"',
                    "\\": "\\",
                    "$": "$",
                }
                out.append(mapping.get(nxt, nxt))
                self.i += 2
                continue
            if c == q:
                self.i += 1
                return "".join(out)
            out.append(c)
            self.i += 1
        raise ValueError("unterminated string")

    def parse_list(self) -> list:
        self.skip()
        assert self.text[self.i] == "["
        self.i += 1
        items: list = []
        while True:
            ch = self.peek()
            if ch == "]":
                self.i += 1
                return items
            if ch == ",":
                self.i += 1
                continue
            items.append(self.parse_value())

    def parse_map(self) -> dict:
        self.skip()
        assert self.text[self.i] == "{"
        self.i += 1
        items: dict = {}
        while True:
            ch = self.peek()
            if ch == "}":
                self.i += 1
                return items
            if ch == ",":
                self.i += 1
                continue
            key = self.parse_string()
            self.skip()
            if self.peek() != ":":
                raise ValueError(f"expected : after key {key!r} at {self.i}")
            self.i += 1
            items[key] = self.parse_value()

    def parse_value(self):
        ch = self.peek()
        if ch in "'\"":
            return self.parse_string()
        if ch == "[":
            return self.parse_list()
        if ch == "{":
            return self.parse_map()
        raise ValueError(f"unexpected {ch!r} at {self.i}")


def _load_const_map(path: Path, name: str) -> dict:
    text = path.read_text(encoding="utf-8")
    m = re.search(rf"{re.escape(name)}\s*=", text)
    if not m:
        raise SystemExit(f"{path}: could not find {name}")
    parser = DartParser(text)
    parser.i = m.end()
    parser.skip()
    # Skip Dart generic type args: <String, Map<...>>{
    if parser.peek() == "<":
        depth = 0
        while parser.i < parser.n:
            c = parser.text[parser.i]
            parser.i += 1
            if c == "<":
                depth += 1
            elif c == ">":
                depth -= 1
                if depth == 0:
                    break
        parser.skip()
    if parser.peek() != "{":
        raise SystemExit(f"{path}: {name} is not a map (got {parser.peek()!r})")
    return parser.parse_map()


def spoken_catalog() -> dict[str, list[tuple[str, str]]]:
    milestones = _load_const_map(LIB / "milestone_lines.dart", "milestoneLines")
    walks = _load_const_map(LIB / "walk_text.dart", "walkLines")
    reflections = _load_const_map(LIB / "reflection_lines.dart", "reflectionClosings")
    out: dict[str, list[tuple[str, str]]] = {}
    for lang in LANGS:
        lines: list[tuple[str, str]] = []
        ms = milestones[lang]
        for style in ("calm", "cheerful"):
            for key, texts in ms[style].items():
                for i, text in enumerate(texts):
                    lines.append((f"milestone_{style}_{key}_{i}", text))
        wl = walks[lang]
        for mood in ("clear", "gratitude", "move", "slow", "energy"):
            for i, text in enumerate(wl[mood]):
                lines.append((f"walk_{mood}_{i}", text))
        rc = reflections[lang]
        for group in ("met", "half", "under"):
            for i, text in enumerate(rc[group]):
                lines.append((f"reflection_{group}_{i}", text))
        lines.append(("voice_sample", VOICE_SAMPLE[lang]))
        out[lang] = lines
    return out


def ffmpeg_exe() -> str:
    try:
        import imageio_ffmpeg

        return imageio_ffmpeg.get_ffmpeg_exe()
    except Exception as exc:  # pragma: no cover
        raise SystemExit(f"ffmpeg not found via imageio-ffmpeg: {exc}") from exc


def download(url: str, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    tmp = dest.with_suffix(dest.suffix + ".part")
    last_err = ""
    for attempt in range(5):
        cmd = [
            "curl.exe",
            "-sS",
            "-L",
            "--fail",
            "--retry",
            "3",
            "--retry-delay",
            "2",
            "--max-redirs",
            "12",
            "-A",
            UA,
            "-o",
            str(tmp),
            url,
        ]
        proc = subprocess.run(cmd, capture_output=True, text=True)
        if proc.returncode == 0 and tmp.exists() and tmp.stat().st_size >= 50:
            tmp.replace(dest)
            return
        last_err = (proc.stderr or proc.stdout or f"exit {proc.returncode}").strip()
        time.sleep(2 ** attempt)
    raise SystemExit(f"download failed {url}: {last_err}")


def ensure_model(stem: str) -> tuple[Path, Path]:
    onnx = CACHE / f"{stem}.onnx"
    cfg = CACHE / f"{stem}.onnx.json"
    if not onnx.exists() or onnx.stat().st_size < 1_000_000:
        print(f"downloading {stem}.onnx", flush=True)
        download(f"{HF}/{stem}.onnx", onnx)
    if not cfg.exists() or cfg.stat().st_size < 100:
        print(f"downloading {stem}.onnx.json", flush=True)
        download(f"{HF}/{stem}.onnx.json", cfg)
    return onnx, cfg


def wav_duration(path: Path) -> float:
    with wave.open(str(path), "rb") as wf:
        frames = wf.getnframes()
        rate = wf.getframerate()
        return frames / float(rate) if rate else 0.0


def ogg_duration(path: Path) -> float:
    """Read duration from the first Ogg Opus header granule if possible."""
    data = path.read_bytes()
    # Prefer ffmpeg probe when available.
    try:
        proc = subprocess.run(
            [
                ffmpeg_exe(),
                "-i",
                str(path),
                "-hide_banner",
            ],
            capture_output=True,
            text=True,
            check=False,
        )
        err = proc.stderr or ""
        m = re.search(r"Duration: (\d+):(\d+):(\d+\.\d+)", err)
        if m:
            return int(m.group(1)) * 3600 + int(m.group(2)) * 60 + float(m.group(3))
    except Exception:
        pass
    # Fallback: tiny files are almost certainly truncated.
    return 0.05 if len(data) < 800 else 1.0


def encode_ogg(wav_path: Path, ogg_path: Path) -> None:
    ogg_path.parent.mkdir(parents=True, exist_ok=True)
    tmp = ogg_path.with_suffix(".tmp.ogg")
    cmd = [
        ffmpeg_exe(),
        "-y",
        "-i",
        str(wav_path),
        "-af",
        "loudnorm=I=-16:TP=-1.5:LRA=11",
        "-ac",
        "1",
        "-c:a",
        "libopus",
        "-b:a",
        "48k",
        "-vbr",
        "on",
        "-application",
        "voip",
        str(tmp),
    ]
    proc = subprocess.run(cmd, capture_output=True, text=True, check=False)
    if proc.returncode != 0 or not tmp.exists() or tmp.stat().st_size < 200:
        raise RuntimeError(f"ffmpeg failed: {proc.stderr[-400:]}")
    tmp.replace(ogg_path)


def expected_seconds(text: str) -> float:
    # Calm speech is roughly 11–13 characters per second; length_scale 1.1
    # stretches that a little.
    return max(0.6, len(text) / 11.5 * 1.1)


def synthesize_one(voice, text: str, speaker_id: int | None, wav_path: Path) -> None:
    from piper.config import SynthesisConfig

    cfg = SynthesisConfig(
        speaker_id=speaker_id,
        length_scale=1.1,
        volume=1.0,
        normalize_audio=True,
    )
    with wave.open(str(wav_path), "wb") as wf:
        voice.synthesize_wav(text, wf, syn_config=cfg)


def render(force: bool = False) -> None:
    from piper import PiperVoice

    catalog = spoken_catalog()
    jobs: dict[str, list[tuple[str, str, str, str, int | None]]] = {}
    for lang in LANGS:
        for gender in VOICES:
            stem, speaker = VOICE_MODELS[(lang, gender)]
            for line_id, text in catalog[lang]:
                jobs.setdefault(stem, []).append((lang, gender, line_id, text, speaker))

    total = sum(len(v) for v in jobs.values())
    done = 0
    skipped = 0
    rendered = 0
    rerendered = 0
    started = time.time()
    print(f"clips to consider: {total}", flush=True)

    for stem, items in jobs.items():
        onnx, cfg = ensure_model(stem)
        print(f"loading {stem}", flush=True)
        voice = PiperVoice.load(onnx, config_path=cfg, use_cuda=False)
        with tempfile.TemporaryDirectory(prefix="qs-voice-") as tmpdir:
            tmpdir_path = Path(tmpdir)
            for lang, gender, line_id, text, speaker in items:
                dest = OUT / lang / gender / f"{line_id}.ogg"
                done += 1
                if dest.exists() and dest.stat().st_size > 400 and not force:
                    skipped += 1
                    if done % 40 == 0:
                        print(
                            f"progress {done}/{total} skipped={skipped} rendered={rendered}",
                            flush=True,
                        )
                    continue
                wav_path = tmpdir_path / f"{lang}_{gender}_{line_id}.wav"
                try:
                    synthesize_one(voice, text, speaker, wav_path)
                    dur = wav_duration(wav_path)
                    expect = expected_seconds(text)
                    if dur < expect * 0.45 and expect > 1.2:
                        synthesize_one(voice, text, speaker, wav_path)
                        rerendered += 1
                    encode_ogg(wav_path, dest)
                    rendered += 1
                except Exception as exc:
                    print(f"FAILED {dest}: {exc}", flush=True)
                    raise
                if done % 20 == 0:
                    elapsed = time.time() - started
                    print(
                        f"progress {done}/{total} rendered={rendered} "
                        f"skipped={skipped} rerender={rerendered} {elapsed:.0f}s",
                        flush=True,
                    )
        del voice

    print(
        f"DONE clips={total} rendered={rendered} skipped={skipped} "
        f"rerender={rerendered} seconds={time.time() - started:.0f}",
        flush=True,
    )


def dump_catalog() -> None:
    catalog = spoken_catalog()
    summary = {
        lang: [{"id": i, "text": t} for i, t in lines]
        for lang, lines in catalog.items()
    }
    print(json.dumps({lang: len(v) for lang, v in summary.items()}, indent=2))
    ids = [i for i, _ in catalog["en"]]
    print("ids:", ", ".join(ids))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--dump", action="store_true")
    args = parser.parse_args()
    os.chdir(ROOT)
    if args.dump:
        dump_catalog()
        return
    status = Path(r"C:\Users\tomas\AppData\Local\Temp\quiet-steps-voices.status")
    try:
        render(force=args.force)
        status.write_text("DONE\n", encoding="utf-8")
    except BaseException as exc:
        if isinstance(exc, SystemExit) and exc.code in (0, None):
            raise
        status.write_text(f"FAILED {exc}\n", encoding="utf-8")
        raise


if __name__ == "__main__":
    main()
