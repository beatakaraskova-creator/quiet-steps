import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/look_pack.dart';

const easyTapMin = 64.0;
const easyTextExtra = 1.4;
const easyTextCap = 1.7;
const easyRingStroke = 20.0;
const easyRingSize = 300.0;
const easyNormalStroke = 12.0;
const easyNormalRingSize = 260.0;

/// Phone font size × 1.4, never below the system scale, capped so layouts hold.
double easyTextScale(double systemScale) {
  final s = systemScale <= 0 ? 1.0 : systemScale;
  final boosted = s * easyTextExtra;
  if (boosted <= easyTextCap) return boosted;
  return math.max(s, easyTextCap);
}

double contrastRatio(Color a, Color b) {
  final l1 = a.computeLuminance();
  final l2 = b.computeLuminance();
  final hi = math.max(l1, l2);
  final lo = math.min(l1, l2);
  return (hi + 0.05) / (lo + 0.05);
}

/// Nudge [fg] toward black or white until contrast with [bg] meets [minRatio].
Color ensureContrast(Color fg, Color bg, double minRatio) {
  if (contrastRatio(fg, bg) >= minRatio) return fg;
  final toward =
      bg.computeLuminance() > 0.45 ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  for (var i = 1; i <= 20; i++) {
    final c = Color.lerp(fg, toward, i / 20)!;
    if (contrastRatio(c, bg) >= minRatio) return c;
  }
  return toward;
}

/// Stronger text/background contrast for Big and simple. WCAG AA or better.
LookPack accessibleLook(LookPack pack) {
  final ink = pack.light ? const Color(0xFF111111) : const Color(0xFFFBF8F1);
  final muted = ensureContrast(
    Color.lerp(ink, pack.bg, 0.28)!,
    pack.bg,
    4.5,
  );
  final card = Color.lerp(pack.bg, ink, pack.light ? 0.10 : 0.14)!;
  final line = ensureContrast(
    Color.lerp(pack.bg, ink, pack.light ? 0.28 : 0.32)!,
    pack.bg,
    3.0,
  );
  final accent = ensureContrast(pack.accent, pack.bg, 3.0);
  return LookPack(
    id: pack.id,
    name: pack.name,
    bg: pack.bg,
    card: card,
    ink: ensureContrast(ink, pack.bg, 7.0),
    muted: muted,
    accent: accent,
    line: line,
    light: pack.light,
  );
}
