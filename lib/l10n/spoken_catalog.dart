import 'milestone_lines.dart';
import 'reflection_lines.dart';
import 'walk_text.dart';
import '../services/milestones.dart';

/// One pre-recorded spoken line. [id] matches `assets/voices/{lang}/{voice}/{id}.ogg`.
class SpokenLine {
  const SpokenLine(this.id, this.text);
  final String id;
  final String text;
}

const voiceGenders = ['female', 'male'];

const voiceSampleLines = {
  'en': 'This is the Quiet Steps voice.',
  'sk': 'Toto je hlas Quiet Steps.',
  'cs': 'Toto je hlas Quiet Steps.',
  'pl': 'To jest głos Quiet Steps.',
  'de': 'Das ist die Stimme von Quiet Steps.',
  'es': 'Esta es la voz de Quiet Steps.',
  'fr': 'Voici la voix de Quiet Steps.',
  'it': 'Questa è la voce di Quiet Steps.',
};

String voiceSampleLine(String language) {
  return voiceSampleLines[language] ?? voiceSampleLines['en']!;
}

List<SpokenLine> spokenLinesFor(String language) {
  final lang = milestoneLines.containsKey(language) ? language : 'en';
  final out = <SpokenLine>[];
  for (final style in const ['calm', 'cheerful']) {
    for (final ms in const ['2500', '5000', '7500', 'goal']) {
      final lines = milestoneLines[lang]![style]![ms]!;
      for (var i = 0; i < lines.length; i++) {
        out.add(SpokenLine('milestone_${style}_${ms}_$i', lines[i]));
      }
    }
  }
  for (final mood in walkMoodIds) {
    final lines = walkLines[lang]![mood]!;
    for (var i = 0; i < lines.length; i++) {
      out.add(SpokenLine('walk_${mood}_$i', lines[i]));
    }
  }
  for (final group in const ['met', 'half', 'under']) {
    final lines = reflectionClosings[lang]![group]!;
    for (var i = 0; i < lines.length; i++) {
      out.add(SpokenLine('reflection_${group}_$i', lines[i]));
    }
  }
  out.add(SpokenLine('voice_sample', voiceSampleLine(lang)));
  return out;
}

String? spokenIdForText(String language, String text) {
  final t = text.trim();
  if (t.isEmpty) return null;
  final lines = spokenLinesFor(language);
  for (final line in lines) {
    if (line.text == t) return line.id;
  }
  SpokenLine? best;
  for (final line in lines) {
    if (line.id == 'voice_sample') continue;
    if (t.contains(line.text) &&
        (best == null || line.text.length > best.text.length)) {
      best = line;
    }
  }
  return best?.id;
}

String voiceClipAsset(String language, String voice, String id) {
  final lang = supportedLanguages.contains(language) ? language : 'en';
  final gender = voiceGenders.contains(voice) ? voice : 'female';
  return 'assets/voices/$lang/$gender/$id.ogg';
}

/// Null means use the phone TTS engine.
String? clipAssetForSpeak({
  required String language,
  required String voiceKind,
  required String text,
  bool Function(String asset)? exists,
}) {
  if (voiceKind == 'phone') return null;
  final id = spokenIdForText(language, text);
  if (id == null) return null;
  final asset = voiceClipAsset(language, voiceKind, id);
  if (exists != null && !exists(asset)) return null;
  return asset;
}
