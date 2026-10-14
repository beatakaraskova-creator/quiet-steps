import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/streak_text.dart';
import '../models/walk_entry.dart';
import '../services/look.dart';
import '../services/milestones.dart';
import '../services/store.dart';
import '../services/walks.dart';

class WalkJournalScreen extends StatefulWidget {
  const WalkJournalScreen({super.key});

  @override
  State<WalkJournalScreen> createState() => _WalkJournalScreenState();
}

class _WalkJournalScreenState extends State<WalkJournalScreen> {
  String get _lang => resolveLanguage(
        stored: Store.instance.language,
        deviceLanguageCode:
            View.of(context).platformDispatcher.locale.languageCode,
      );

  Future<void> _confirmDelete(WalkEntry entry) async {
    final p = Look.instance.pack;
    final lang = _lang;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.card,
        title: Text(walkUiLine(lang, 'deleteTitle')),
        content: Text(walkUiLine(lang, 'deleteBody')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(walkUiLine(lang, 'keep')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              walkUiLine(lang, 'delete'),
              style: TextStyle(color: p.accent),
            ),
          ),
        ],
      ),
    );
    if (ok == true) {
      await Store.instance.deleteWalk(entry.id);
      if (mounted) setState(() {});
    }
  }

  String _dateLabel(String iso, String lang) {
    try {
      final d = DateTime.parse(iso).toLocal();
      return DateFormat.MMMEd(lang).format(d);
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Look.instance.pack;
    final lang = _lang;
    final items = Store.instance.walks();
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: p.bg,
        foregroundColor: p.ink,
        title: Text(walkUiLine(lang, 'journal')),
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                walkUiLine(lang, 'empty'),
                style: TextStyle(color: p.muted),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final w = items[i];
                return Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                  decoration: BoxDecoration(
                    color: p.card,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_dateLabel(w.endedAt, lang)}  ·  ${walkMoodLabel(lang, w.mood)}',
                              style: TextStyle(color: p.ink, fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${StreakText.steps(lang, w.steps)}  ·  ${walkMinutesLabel(lang, w.minutes)}',
                              style: TextStyle(
                                color: p.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (w.note.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                w.note,
                                style: TextStyle(
                                  color: p.muted,
                                  height: 1.4,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: walkUiLine(lang, 'delete'),
                        onPressed: () => _confirmDelete(w),
                        icon: Icon(Icons.delete_outline, color: p.muted),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
