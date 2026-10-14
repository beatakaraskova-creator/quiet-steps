import 'package:flutter/material.dart';

import '../l10n/app_text.dart';
import '../models/look_pack.dart';
import '../services/look.dart';
import '../services/milestones.dart';
import '../services/step_engine.dart';
import '../services/store.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController goal;
  late final TextEditingController height;
  late final TextEditingController stride;
  late final TextEditingController weight;

  late String _language;
  late bool _milestoneOn;
  late bool _speakOn;
  late String _voiceSpeed;
  late String _style;
  late bool _quietOn;
  late String _quietStart;
  late String _quietEnd;

  @override
  void initState() {
    super.initState();
    final s = Store.instance;
    goal = TextEditingController(text: '${s.goal}');
    height = TextEditingController(text: '${s.heightCm}');
    stride = TextEditingController(text: '${s.strideCm}');
    weight = TextEditingController(text: '${s.weightKg}');
    _language = s.language;
    _milestoneOn = s.milestoneMessages;
    _speakOn = s.speakMessages;
    _voiceSpeed = s.voiceSpeed;
    _style = s.milestoneStyle;
    _quietOn = s.quietHours;
    _quietStart = s.quietStart;
    _quietEnd = s.quietEnd;
  }

  @override
  void dispose() {
    goal.dispose();
    height.dispose();
    stride.dispose();
    weight.dispose();
    super.dispose();
  }

  void _save() {
    final s = Store.instance;
    final parsedGoal = int.tryParse(goal.text);
    if (parsedGoal != null && parsedGoal < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppText.goalMustBe100)),
      );
      return;
    }
    if (parsedGoal != null) {
      s.goal = parsedGoal;
    }
    s.heightCm = int.tryParse(height.text) ?? s.heightCm;
    s.strideCm = int.tryParse(stride.text) ?? s.strideCm;
    s.weightKg = int.tryParse(weight.text) ?? s.weightKg;
    _writeMilestonePrefs();
    StepEngine.instance.syncTaskPrefs();
    Navigator.of(context).pop();
  }

  void _writeMilestonePrefs() {
    final s = Store.instance;
    s.language = _language;
    s.milestoneMessages = _milestoneOn;
    s.speakMessages = _speakOn;
    s.voiceSpeed = _voiceSpeed;
    s.milestoneStyle = _style;
    s.quietHours = _quietOn;
    s.quietStart = _quietStart;
    s.quietEnd = _quietEnd;
  }

  void _touchMilestone(VoidCallback fn) {
    setState(fn);
    _writeMilestonePrefs();
    StepEngine.instance.syncTaskPrefs();
  }

  Future<void> _pickTime({required bool start}) async {
    final raw = start ? _quietStart : _quietEnd;
    final mins = minutesFromHm(raw);
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: mins ~/ 60, minute: mins % 60),
      builder: (context, child) {
        final p = Look.instance.pack;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: p.accent,
              surface: p.card,
              onSurface: p.ink,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked == null) return;
    _touchMilestone(() {
      final hm = formatHm(picked.hour, picked.minute);
      if (start) {
        _quietStart = hm;
      } else {
        _quietEnd = hm;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = Look.instance.pack;
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: p.bg,
        foregroundColor: p.ink,
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('Save', style: TextStyle(color: p.accent)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          _field(AppText.goalLabel, goal, p),
          _field('Height (cm)', height, p),
          _field('Stride (cm)', stride, p),
          _field('Weight (kg) — for kcal estimate only', weight, p),
          const SizedBox(height: 12),
          _languageTile(p),
          _switchTile(
            AppText.milestoneMessages,
            _milestoneOn,
            (v) => _touchMilestone(() => _milestoneOn = v),
            p,
          ),
          _switchTile(
            AppText.speakMessages,
            _speakOn,
            (v) => _touchMilestone(() => _speakOn = v),
            p,
          ),
          _choiceRow(
            AppText.voiceSpeed,
            const [
              ('slow', AppText.voiceSlow),
              ('normal', AppText.voiceNormal),
            ],
            _voiceSpeed,
            (v) => _touchMilestone(() => _voiceSpeed = v),
            p,
          ),
          _choiceRow(
            AppText.style,
            const [
              ('calm', AppText.styleCalm),
              ('cheerful', AppText.styleCheerful),
            ],
            _style,
            (v) => _touchMilestone(() => _style = v),
            p,
          ),
          _switchTile(
            AppText.quietHours,
            _quietOn,
            (v) => _touchMilestone(() => _quietOn = v),
            p,
          ),
          _timeTile(AppText.quietStart, _quietStart, () => _pickTime(start: true), p),
          _timeTile(AppText.quietEnd, _quietEnd, () => _pickTime(start: false), p),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: p.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Quiet Steps is not a medical device. It does not diagnose, treat, cure or prevent any condition.\n\n'
              'Steps come from the phone sensor. Distance and calories are estimates from the numbers you type here.\n\n'
              'Nothing is uploaded. There is no account. GPS is not used.',
              style: TextStyle(color: p.muted, height: 1.45, fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageTile(LookPack p) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 6, 12, 6),
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                AppText.language,
                style: TextStyle(color: p.ink, fontSize: 16),
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: languageOptions.contains(_language) ? _language : 'auto',
                dropdownColor: p.card,
                style: TextStyle(color: p.ink, fontSize: 15),
                items: [
                  for (final code in languageOptions)
                    DropdownMenuItem(
                      value: code,
                      child: Text(languageLabels[code] ?? code),
                    ),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  _touchMilestone(() => _language = v);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
    LookPack p,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SwitchListTile(
          title: Text(label, style: TextStyle(color: p.ink, fontSize: 16)),
          value: value,
          onChanged: onChanged,
          activeThumbColor: p.accent,
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
        ),
      ),
    );
  }

  Widget _choiceRow(
    String label,
    List<(String, String)> options,
    String value,
    ValueChanged<String> onPick,
    LookPack p,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: p.ink, fontSize: 16)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                for (final opt in options)
                  ChoiceChip(
                    label: Text(opt.$2),
                    selected: value == opt.$1,
                    onSelected: (_) => onPick(opt.$1),
                    selectedColor: p.accent,
                    backgroundColor: p.bg,
                    labelStyle: TextStyle(
                      color: value == opt.$1 ? p.bg : p.ink,
                    ),
                    side: BorderSide.none,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeTile(
    String label,
    String value,
    VoidCallback onTap,
    LookPack p,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: p.card,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          title: Text(label, style: TextStyle(color: p.ink, fontSize: 16)),
          trailing: Text(
            value,
            style: TextStyle(color: p.accent, fontSize: 16),
          ),
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c, LookPack p) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        style: TextStyle(color: p.ink),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: p.muted),
          filled: true,
          fillColor: p.card,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
