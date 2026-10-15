import 'package:flutter/material.dart';

import '../l10n/ui_text.dart';
import '../models/look_pack.dart';
import '../services/app_locale.dart';
import '../services/look.dart';
import '../widgets/colour_wheel.dart';
import 'photo_crop_screen.dart';

class LookScreen extends StatelessWidget {
  const LookScreen({super.key});

  Future<void> _openWheel(
    BuildContext context,
    Look look, {
    required bool background,
  }) async {
    final start = look.pack;
    final lang = currentLanguage();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: start.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        final p = look.pack;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            16 + MediaQuery.of(ctx).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: p.line,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                background
                    ? uiLine(lang, 'background')
                    : uiLine(lang, 'accent'),
                style: TextStyle(
                  color: p.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                background
                    ? uiLine(lang, 'backgroundHint')
                    : uiLine(lang, 'accentHint'),
                style: TextStyle(color: p.muted, fontSize: 13),
              ),
              const SizedBox(height: 18),
              ColourWheel(
                color: background ? look.basePack.bg : look.basePack.accent,
                onChanged: (c) {
                  if (background) {
                    look.setCustomColors(bg: c);
                  } else {
                    look.setCustomColors(accent: c);
                  }
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: FilledButton.styleFrom(
                    backgroundColor: p.accent,
                    foregroundColor: p.onAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(uiLine(lang, 'done')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final look = Look.instance;
    return AnimatedBuilder(
      animation: look,
      builder: (context, _) {
        final p = look.pack;
        final lang = currentLanguage();
        final hasPhoto = look.backgroundPath != null;
        final customOn = p.id == 'custom';
        return Scaffold(
          backgroundColor: p.bg,
          appBar: AppBar(
            title: Text(uiLine(lang, 'lookTitle')),
            backgroundColor: p.bg,
            foregroundColor: p.ink,
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              Text(
                uiLine(lang, 'yourColours'),
                style: TextStyle(color: p.muted, letterSpacing: 1.2),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: p.card,
                  borderRadius: BorderRadius.circular(16),
                  border: customOn
                      ? Border.all(color: p.accent, width: 2)
                      : Border.all(color: Colors.transparent, width: 2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _colourCircle(
                        label: uiLine(lang, 'accent'),
                        hint: uiLine(lang, 'tapToPick'),
                        color: p.accent,
                        ink: p.ink,
                        muted: p.muted,
                        onTap: () => _openWheel(context, look, background: false),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _colourCircle(
                        label: uiLine(lang, 'background'),
                        hint: uiLine(lang, 'tapToPick'),
                        color: p.bg,
                        ink: p.ink,
                        muted: p.muted,
                        onTap: () => _openWheel(context, look, background: true),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                uiLine(lang, 'packs'),
                style: TextStyle(color: p.muted, letterSpacing: 1.2),
              ),
              const SizedBox(height: 10),
              ...LookPack.builtIn.map((pack) {
                final on = !customOn && pack.id == p.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () => look.setPack(pack),
                    tileColor: pack.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: on
                          ? BorderSide(color: pack.accent, width: 2)
                          : BorderSide.none,
                    ),
                    leading: CircleAvatar(backgroundColor: pack.accent),
                    title: Text(
                      uiLine(lang, 'pack_${pack.id}'),
                      style: TextStyle(color: pack.ink),
                    ),
                    trailing: on ? Icon(Icons.check, color: pack.accent) : null,
                  ),
                );
              }),
              const SizedBox(height: 22),
              Text(
                uiLine(lang, 'backgroundPhoto'),
                style: TextStyle(color: p.muted, letterSpacing: 1.2),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () async {
                  final file = await look.pickPhotoFile();
                  if (file == null || !context.mounted) return;
                  final used = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => PhotoCropScreen(file: file),
                    ),
                  );
                  if (used == true) {
                    await look.keepPickedSource(file);
                  }
                  if (await file.exists()) {
                    await file.delete();
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: p.accent,
                  foregroundColor: p.onAccent,
                ),
                child: Text(
                  hasPhoto
                      ? uiLine(lang, 'changePhoto')
                      : uiLine(lang, 'usePhoto'),
                ),
              ),
              if (hasPhoto)
                TextButton(
                  onPressed: () async {
                    final src = await look.cropSourceFile();
                    if (src == null || !context.mounted) return;
                    await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => PhotoCropScreen(file: src),
                      ),
                    );
                  },
                  child: Text(uiLine(lang, 'cropPhoto'), style: TextStyle(color: p.accent)),
                ),
              if (hasPhoto)
                TextButton(
                  onPressed: look.clearPhoto,
                  child: Text(uiLine(lang, 'removePhoto'), style: TextStyle(color: p.muted)),
                ),
              const SizedBox(height: 18),
              Text(
                uiLine(lang, 'typeSize'),
                style: TextStyle(color: p.muted, letterSpacing: 1.2),
              ),
              Slider(
                value: look.fontScale,
                min: 0.85,
                max: 1.35,
                divisions: 10,
                activeColor: p.accent,
                label: look.fontScale.toStringAsFixed(2),
                onChanged: look.setFontScale,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: p.card,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  uiLine(lang, 'lookHint'),
                  style: TextStyle(color: p.muted, height: 1.45, fontSize: 13.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _colourCircle({
    required String label,
    required String hint,
    required Color color,
    required Color ink,
    required Color muted,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: ink.withValues(alpha: 0.35), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(color: ink, fontWeight: FontWeight.w600),
            ),
            Text(
              hint,
              style: TextStyle(color: muted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
