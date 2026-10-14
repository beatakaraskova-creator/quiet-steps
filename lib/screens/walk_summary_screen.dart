import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/streak_text.dart';
import '../models/walk_entry.dart';
import '../services/look.dart';
import '../services/milestones.dart';
import '../services/store.dart';
import '../services/voice.dart';
import '../services/walks.dart';

class WalkSummaryScreen extends StatefulWidget {
  const WalkSummaryScreen({
    super.key,
    required this.entry,
    required this.line,
    required this.language,
  });

  final WalkEntry entry;
  final String line;
  final String language;

  @override
  State<WalkSummaryScreen> createState() => _WalkSummaryScreenState();
}

class _WalkSummaryScreenState extends State<WalkSummaryScreen> {
  late final TextEditingController _note;

  @override
  void initState() {
    super.initState();
    _note = TextEditingController(text: widget.entry.note);
    final store = Store.instance;
    final quiet = store.quietHours &&
        inQuietHours(
          start: store.quietStart,
          end: store.quietEnd,
          now: DateTime.now(),
        );
    if (store.speakMessages && !quiet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Voice.instance.speak(
          text: widget.line,
          language: widget.language,
          speed: store.voiceSpeed,
          style: store.milestoneStyle,
        );
      });
    }
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final saved = WalkEntry(
      id: widget.entry.id,
      mood: widget.entry.mood,
      steps: widget.entry.steps,
      minutes: widget.entry.minutes,
      note: clipWalkNote(_note.text),
      startedAt: widget.entry.startedAt,
      endedAt: widget.entry.endedAt,
    );
    await Store.instance.addWalk(saved);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final p = Look.instance.pack;
    final scale = Look.instance.fontScale;
    final lang = widget.language;
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: p.bg,
        foregroundColor: p.ink,
        title: Text(walkMoodLabel(lang, widget.entry.mood)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        children: [
          Text(
            StreakText.steps(lang, widget.entry.steps),
            style: TextStyle(
              color: p.ink,
              fontSize: 28 * scale,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            walkMinutesLabel(lang, widget.entry.minutes),
            style: TextStyle(color: p.muted, fontSize: 16 * scale),
          ),
          const SizedBox(height: 22),
          Text(
            widget.line,
            style: TextStyle(
              color: p.ink,
              fontSize: 18 * scale,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 28),
          TextField(
            controller: _note,
            maxLength: maxWalkNote,
            maxLines: 4,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxWalkNote),
            ],
            style: TextStyle(color: p.ink),
            decoration: InputDecoration(
              hintText: walkUiLine(lang, 'noteHint'),
              hintStyle: TextStyle(color: p.muted),
              filled: true,
              fillColor: p.card,
              counterStyle: TextStyle(color: p.muted, fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(
              backgroundColor: p.accent,
              foregroundColor: p.onAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(walkUiLine(lang, 'save')),
          ),
        ],
      ),
    );
  }
}
