import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/popup_text.dart';
import '../l10n/ui_text.dart';
import '../services/app_locale.dart';
import '../services/look.dart';

/// Shown as copyable text, not a tappable link: opening a browser would need
/// url_launcher and a `<queries>` entry, and this app stays offline.
const privacyPolicyUrl = 'https://web.wainshop.com/quiet-steps-privacy';

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
                const SizedBox(height: 12),
                Text(
                  popupLine(lang, 'fontCredit'),
                  key: const ValueKey('credits-font'),
                  style: TextStyle(color: p.muted, height: 1.5, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            key: const ValueKey('credits-privacy'),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            decoration: BoxDecoration(
              color: p.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  uiLine(lang, 'privacyTitle'),
                  style: TextStyle(
                    color: p.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  uiLine(lang, 'privacyHint'),
                  style: TextStyle(color: p.muted, height: 1.45, fontSize: 14),
                ),
                const SizedBox(height: 6),
                SelectableText(
                  privacyPolicyUrl,
                  key: const ValueKey('credits-privacy-url'),
                  style: TextStyle(color: p.ink, height: 1.45, fontSize: 14),
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    key: const ValueKey('credits-privacy-copy'),
                    style: TextButton.styleFrom(
                      foregroundColor: p.ink,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await Clipboard.setData(
                        const ClipboardData(text: privacyPolicyUrl),
                      );
                      messenger.showSnackBar(
                        SnackBar(content: Text(uiLine(lang, 'privacyCopied'))),
                      );
                    },
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: Text(uiLine(lang, 'privacyCopy')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
