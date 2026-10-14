import 'package:flutter/material.dart';

/// A look pack is only visuals. Step logic never reads this file.
/// Later a paid pack is just another LookPack (id, colours, type scale).
class LookPack {
  const LookPack({
    required this.id,
    required this.name,
    required this.bg,
    required this.card,
    required this.ink,
    required this.muted,
    required this.accent,
    required this.line,
    this.light = false,
  });

  final String id;
  final String name;
  final Color bg;
  final Color card;
  final Color ink;
  final Color muted;
  final Color accent;
  final Color line;
  final bool light;

  static const quietGold = LookPack(
    id: 'quiet_gold',
    name: 'Quiet gold',
    bg: Color(0xFF141412),
    card: Color(0xFF1E1E1B),
    ink: Color(0xFFF3EFE6),
    muted: Color(0xFFA8A29A),
    accent: Color(0xFFC4A574),
    line: Color(0xFF2C2C28),
  );

  static const nightMoss = LookPack(
    id: 'night_moss',
    name: 'Night moss',
    bg: Color(0xFF0F1612),
    card: Color(0xFF18241C),
    ink: Color(0xFFE7F0E8),
    muted: Color(0xFF8FA395),
    accent: Color(0xFF8FBC8F),
    line: Color(0xFF24332A),
  );

  static const ember = LookPack(
    id: 'ember',
    name: 'Ember',
    bg: Color(0xFF1A1010),
    card: Color(0xFF2A1818),
    ink: Color(0xFFF8EDE8),
    muted: Color(0xFFC4A8A0),
    accent: Color(0xFFE08A6A),
    line: Color(0xFF3A2424),
  );

  static const paper = LookPack(
    id: 'paper',
    name: 'Paper',
    bg: Color(0xFFF4EFE6),
    card: Color(0xFFFFFFFF),
    ink: Color(0xFF1C1916),
    muted: Color(0xFF7A736A),
    accent: Color(0xFF8B5E3C),
    line: Color(0xFFE4DCD0),
    light: true,
  );

  static const List<LookPack> builtIn = [
    quietGold,
    nightMoss,
    ember,
    paper,
  ];

  static LookPack byId(String id) {
    return builtIn.firstWhere(
      (p) => p.id == id,
      orElse: () => quietGold,
    );
  }

  /// Accent + background chosen on the colour wheel.
  /// Card, text and lines are derived so type stays readable.
  static LookPack custom({required Color bg, required Color accent}) {
    final light = bg.computeLuminance() > 0.45;
    final ink = light ? const Color(0xFF1C1916) : const Color(0xFFF3EFE6);
    final muted = Color.lerp(ink, bg, 0.45)!;
    final card = Color.lerp(bg, ink, light ? 0.08 : 0.10)!;
    final line = Color.lerp(bg, ink, light ? 0.16 : 0.18)!;
    return LookPack(
      id: 'custom',
      name: 'Your colours',
      bg: bg,
      card: card,
      ink: ink,
      muted: muted,
      accent: accent,
      line: line,
      light: light,
    );
  }

  Color get onAccent =>
      accent.computeLuminance() > 0.45 ? const Color(0xFF1A1208) : Colors.white;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'bg': bg.toARGB32(),
        'card': card.toARGB32(),
        'ink': ink.toARGB32(),
        'muted': muted.toARGB32(),
        'accent': accent.toARGB32(),
        'line': line.toARGB32(),
        'light': light,
      };
}
