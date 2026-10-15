import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';

import '../l10n/app_text.dart';
import '../l10n/easy_text.dart';
import '../models/look_pack.dart';
import '../services/milestones.dart';
import '../services/look.dart';
import '../services/step_engine.dart';
import '../services/store.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pages = PageController();
  late final TextEditingController _goal;
  int _index = 0;
  bool _busy = false;
  bool _easy = false;

  @override
  void initState() {
    super.initState();
    _goal = TextEditingController(text: '${Store.instance.goal}');
  }

  @override
  void dispose() {
    _pages.dispose();
    _goal.dispose();
    super.dispose();
  }

  void _goTo(int i) {
    _pages.animateToPage(
      i,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  String get _onboardLang => resolveLanguage(
        stored: Store.instance.language,
        deviceLanguageCode: PlatformDispatcher.instance.locale.languageCode,
      );

  Future<void> _next() async {
    if (_index < 2) {
      _goTo(_index + 1);
      return;
    }
    await _finish();
  }

  Future<void> _finish() async {
    if (_busy) return;
    final parsed = int.tryParse(_goal.text.trim());
    if (parsed == null || parsed < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppText.goalMustBe100)),
      );
      return;
    }
    setState(() => _busy = true);
    Store.instance.goal = parsed;
    Store.instance.onboardingDone = true;
    await Look.instance.setBigSimple(_easy);
    await StepEngine.instance.start();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Look.instance.pack;
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: p.bg,
        foregroundColor: p.ink,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          if (_index < 2)
            TextButton(
              onPressed: () => _goTo(2),
              child: Text(AppText.skip, style: TextStyle(color: p.muted)),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pages,
                  onPageChanged: (i) => setState(() => _index = i),
                  children: [
                    _page(
                      p,
                      title: AppText.appName,
                      body: AppText.page1Body,
                      showIcon: true,
                    ),
                    _page(
                      p,
                      title: AppText.page2Title,
                      body: AppText.page2Body,
                    ),
                    _page(
                      p,
                      title: AppText.page3Title,
                      body: AppText.page3Body,
                      showGoal: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final on = i == _index;
                  return Container(
                    width: on ? 18 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: on ? p.accent : p.line,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _busy ? null : _next,
                  style: FilledButton.styleFrom(
                    backgroundColor: p.accent,
                    foregroundColor: p.onAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _busy
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: p.onAccent,
                          ),
                        )
                      : Text(
                          _index == 2 ? AppText.getStarted : AppText.next,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _page(
    LookPack p, {
    required String title,
    required String body,
    bool showIcon = false,
    bool showGoal = false,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),
          if (showIcon) ...[
            Image.asset(
              'assets/icon/icon.png',
              width: 168,
              height: 168,
            ),
            const SizedBox(height: 28),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: p.ink,
              fontSize: 28 * Look.instance.fontScale,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: p.muted,
              fontSize: 16 * Look.instance.fontScale,
              height: 1.45,
            ),
          ),
          if (showGoal) ...[
            const SizedBox(height: 28),
            TextField(
              controller: _goal,
              keyboardType: TextInputType.number,
              style: TextStyle(color: p.ink),
              decoration: InputDecoration(
                labelText: AppText.goalLabel,
                labelStyle: TextStyle(color: p.muted),
                filled: true,
                fillColor: p.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                easyUiLine(_onboardLang, 'title'),
                style: TextStyle(color: p.ink, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                easyUiLine(_onboardLang, 'onboarding'),
                style: TextStyle(color: p.muted),
              ),
              value: _easy,
              onChanged: (v) => setState(() => _easy = v),
              activeThumbColor: p.accent,
            ),
          ],
        ],
      ),
    );
  }
}
