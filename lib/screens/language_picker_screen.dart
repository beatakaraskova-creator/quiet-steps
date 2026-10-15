import 'package:flutter/material.dart';

import '../l10n/ui_text.dart';
import '../models/look_pack.dart';
import '../services/app_locale.dart';
import '../services/easy_mode.dart';
import '../services/glance.dart';
import '../services/look.dart';
import '../services/milestones.dart';
import '../services/store.dart';
import 'onboarding_screen.dart';

class LanguagePickerScreen extends StatefulWidget {
  const LanguagePickerScreen({super.key});

  @override
  State<LanguagePickerScreen> createState() => _LanguagePickerScreenState();
}

class _LanguagePickerScreenState extends State<LanguagePickerScreen> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = suggestedLanguage();
  }

  Future<void> _continue() async {
    Store.instance.language = _selected;
    Store.instance.languagePicked = true;
    AppLocale.instance.load();
    scheduleQuietStepsWidgetPush(force: true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Look.instance.pack;
    final easy = Look.instance.bigSimple;
    final lang = _selected;
    return Scaffold(
      key: const ValueKey('language-picker'),
      backgroundColor: p.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                uiLine(lang, 'languageTitle'),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: p.ink,
                  fontSize: 26 * Look.instance.fontScale,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    for (final code in supportedLanguages)
                      _LanguageTile(
                        code: code,
                        selected: _selected == code,
                        pack: p,
                        easy: easy,
                        onTap: () => setState(() => _selected = code),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                key: const ValueKey('language-continue'),
                onPressed: _continue,
                style: FilledButton.styleFrom(
                  backgroundColor: p.accent,
                  foregroundColor: p.onAccent,
                  minimumSize: Size(double.infinity, easy ? easyTapMin : 56),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  uiLine(lang, 'continue'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.code,
    required this.selected,
    required this.pack,
    required this.easy,
    required this.onTap,
  });

  final String code;
  final bool selected;
  final LookPack pack;
  final bool easy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: pack.card,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          key: ValueKey('lang-$code'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: easy ? easyTapMin : 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      languageLabels[code] ?? code,
                      style: TextStyle(
                        color: pack.ink,
                        fontSize: 18,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    selected ? Icons.check_circle : Icons.circle_outlined,
                    color: selected ? pack.accent : pack.muted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
