import 'package:flutter/material.dart';

import '../models/look_pack.dart';
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
                background ? 'Background colour' : 'Accent colour',
                style: TextStyle(
                  color: p.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                background
                    ? 'The page behind the ring and cards'
                    : 'The ring, buttons and highlights',
                style: TextStyle(color: p.muted, fontSize: 13),
              ),
              const SizedBox(height: 18),
              ColourWheel(
                color: background ? p.bg : p.accent,
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
                  child: const Text('Done'),
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
        final hasPhoto = look.backgroundPath != null;
        final customOn = p.id == 'custom';
        return Scaffold(
          backgroundColor: p.bg,
          appBar: AppBar(
            title: const Text('Look'),
            backgroundColor: p.bg,
            foregroundColor: p.ink,
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              Text(
                'Your colours',
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
                        label: 'Accent',
                        color: p.accent,
                        ink: p.ink,
                        muted: p.muted,
                        onTap: () => _openWheel(context, look, background: false),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _colourCircle(
                        label: 'Background',
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
                'Packs',
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
                    title: Text(pack.name, style: TextStyle(color: pack.ink)),
                    trailing: on ? Icon(Icons.check, color: pack.accent) : null,
                  ),
                );
              }),
              const SizedBox(height: 22),
              Text(
                'Background photo',
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
                child: Text(hasPhoto ? 'Change photo' : 'Use a photo (dog, walk, anything)'),
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
                  child: Text('Crop photo', style: TextStyle(color: p.accent)),
                ),
              if (hasPhoto)
                TextButton(
                  onPressed: look.clearPhoto,
                  child: Text('Remove photo', style: TextStyle(color: p.muted)),
                ),
              const SizedBox(height: 18),
              Text(
                'Type size',
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
                  'Tap a colour circle to pick any colour. '
                  'Accent is the ring and buttons. Background is the page when there is no photo. '
                  'A photo sits behind the numbers — crop it so the part you want fills the screen.',
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
              'Tap to pick',
              style: TextStyle(color: muted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
