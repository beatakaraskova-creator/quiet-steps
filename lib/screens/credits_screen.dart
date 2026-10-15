import 'package:flutter/material.dart';

import '../l10n/ui_text.dart';
import '../services/app_locale.dart';
import '../services/look.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Look.instance.pack;
    final lang = currentLanguage();
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        title: Text(uiLine(lang, 'aboutTitle')),
        backgroundColor: p.bg,
        foregroundColor: p.ink,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: BoxDecoration(
              color: p.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  uiLine(lang, 'aboutIntro'),
                  style: TextStyle(color: p.ink, height: 1.45, fontSize: 15),
                ),
                const SizedBox(height: 16),
                Text(
                  uiLine(lang, 'aboutVoices'),
                  style: TextStyle(color: p.muted, height: 1.5, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
