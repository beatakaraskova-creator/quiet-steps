import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_text.dart';
import '../models/look_pack.dart';
import '../services/backup.dart';
import '../services/glance.dart';
import '../services/look.dart';
import '../services/milestones.dart';
import '../services/reflection.dart';
import '../services/reflection_alerts.dart';
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
  late bool _eveningOn;
  late String _reflectionTime;
  bool _busy = false;

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
    _eveningOn = s.eveningReflection;
    _reflectionTime = s.reflectionTime;
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
    ReflectionAlerts.instance.syncSchedule(Store.instance);
    scheduleQuietStepsWidgetPush(force: true);
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
    s.eveningReflection = _eveningOn;
    s.reflectionTime = _reflectionTime;
  }

  void _touchMilestone(VoidCallback fn) {
    setState(fn);
    _writeMilestonePrefs();
    StepEngine.instance.syncTaskPrefs();
    ReflectionAlerts.instance.syncSchedule(Store.instance);
    scheduleQuietStepsWidgetPush(force: true);
  }

  Future<void> _pickTime({required bool start, bool reflection = false}) async {
    final raw = reflection
        ? _reflectionTime
        : (start ? _quietStart : _quietEnd);
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
      if (reflection) {
        _reflectionTime = hm;
      } else if (start) {
        _quietStart = hm;
      } else {
        _quietEnd = hm;
      }
    });
  }

  String get _lang => resolveLanguage(
        stored: _language,
        deviceLanguageCode:
            View.of(context).platformDispatcher.locale.languageCode,
      );

  Future<void> _snack(String msg) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Uint8List _backupBytes() {
    final json = encodeBackup(snapshotFromStore(Store.instance));
    return Uint8List.fromList(utf8.encode(json));
  }

  Future<void> _exportMenu() async {
    if (_busy) return;
    final p = Look.instance.pack;
    final lang = _lang;
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: p.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    backupUiLine(lang, 'saveFile'),
                    style: TextStyle(color: p.ink),
                  ),
                  onTap: () => Navigator.pop(ctx, 'save'),
                ),
                ListTile(
                  title: Text(
                    backupUiLine(lang, 'share'),
                    style: TextStyle(color: p.ink),
                  ),
                  onTap: () => Navigator.pop(ctx, 'share'),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (choice == 'save') await _exportSave();
    if (choice == 'share') await _exportShare();
  }

  Future<void> _exportSave() async {
    final lang = _lang;
    setState(() => _busy = true);
    try {
      final name = backupFileName(DateTime.now());
      final path = await FilePicker.platform.saveFile(
        dialogTitle: backupUiLine(lang, 'saveFile'),
        fileName: name,
        type: FileType.custom,
        allowedExtensions: const ['json'],
        bytes: _backupBytes(),
      );
      if (path == null) {
        await _snack(backupUiLine(lang, 'cancelled'));
        return;
      }
      await _snack(backupUiLine(lang, 'exported'));
    } catch (_) {
      await _snack(backupUiLine(lang, 'exportFailed'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _exportShare() async {
    final lang = _lang;
    setState(() => _busy = true);
    try {
      final name = backupFileName(DateTime.now());
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(_backupBytes(), flush: true);
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(file.path, mimeType: 'application/json', name: name),
          ],
        ),
      );
    } catch (_) {
      await _snack(backupUiLine(lang, 'exportFailed'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    if (_busy) return;
    final lang = _lang;
    setState(() => _busy = true);
    try {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['json'],
        withData: true,
      );
      if (picked == null || picked.files.isEmpty) {
        await _snack(backupUiLine(lang, 'cancelled'));
        return;
      }
      final file = picked.files.single;
      var bytes = file.bytes;
      if (bytes == null && file.path != null) {
        bytes = await File(file.path!).readAsBytes();
      }
      if (bytes == null) {
        await _snack(backupUiLine(lang, 'invalid'));
        return;
      }
      final parsed = parseBackup(utf8.decode(bytes));
      if (!parsed.isOk) {
        final key =
            parsed.error == BackupError.tooNew ? 'tooNew' : 'invalid';
        await _snack(backupUiLine(lang, key));
        return;
      }
      final data = parsed.snapshot!;
      if (!mounted) return;
      final choice = await _confirmImport(data);
      if (choice == null) return;
      await applyBackupToStore(Store.instance, data, replace: choice);
      await Look.instance.load();
      _reloadFromStore();
      StepEngine.instance.syncTaskPrefs();
      ReflectionAlerts.instance.syncSchedule(Store.instance);
      scheduleQuietStepsWidgetPush(force: true);
      await _snack(backupUiLine(lang, 'done'));
    } catch (_) {
      await _snack(backupUiLine(lang, 'failed'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool?> _confirmImport(BackupSnapshot data) async {
    final p = Look.instance.pack;
    final lang = _lang;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.card,
        title: Text(backupUiLine(lang, 'confirmTitle')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              backupConfirmBody(
                lang,
                days: data.history.length,
                walks: data.walks.length,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              backupUiLine(lang, 'mergeHint'),
              style: TextStyle(color: p.muted, fontSize: 13, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(backupUiLine(lang, 'keep')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(backupUiLine(lang, 'replace')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              backupUiLine(lang, 'merge'),
              style: TextStyle(color: p.accent),
            ),
          ),
        ],
      ),
    );
  }

  void _reloadFromStore() {
    final s = Store.instance;
    goal.text = '${s.goal}';
    height.text = '${s.heightCm}';
    stride.text = '${s.strideCm}';
    weight.text = '${s.weightKg}';
    _language = s.language;
    _milestoneOn = s.milestoneMessages;
    _speakOn = s.speakMessages;
    _voiceSpeed = s.voiceSpeed;
    _style = s.milestoneStyle;
    _quietOn = s.quietHours;
    _quietStart = s.quietStart;
    _quietEnd = s.quietEnd;
    _eveningOn = s.eveningReflection;
    _reflectionTime = s.reflectionTime;
  }

  Widget _backupSection(String lang, LookPack p) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            backupUiLine(lang, 'section'),
            style: TextStyle(
              color: p.ink,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _busy ? null : _exportMenu,
            style: OutlinedButton.styleFrom(
              foregroundColor: p.ink,
              side: BorderSide(color: p.line),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(backupUiLine(lang, 'export')),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _busy ? null : _import,
            style: OutlinedButton.styleFrom(
              foregroundColor: p.ink,
              side: BorderSide(color: p.line),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(backupUiLine(lang, 'import')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Look.instance.pack;
    final lang = resolveLanguage(
      stored: _language,
      deviceLanguageCode: View.of(context).platformDispatcher.locale.languageCode,
    );
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
          _switchTile(
            reflectionUiLine(lang, 'setting'),
            _eveningOn,
            (v) => _touchMilestone(() => _eveningOn = v),
            p,
          ),
          _timeTile(
            reflectionUiLine(lang, 'setting'),
            _reflectionTime,
            () => _pickTime(start: true, reflection: true),
            p,
          ),
          const SizedBox(height: 8),
          _backupSection(lang, p),
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
