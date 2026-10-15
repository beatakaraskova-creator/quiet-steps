import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/ui_text.dart';
import '../models/day_record.dart';
import '../services/app_locale.dart';
import '../services/format.dart';
import '../services/look.dart';
import '../services/store.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Store.instance;
    final p = Look.instance.pack;
    final lang = currentLanguage();
    final items = <DayRecord>[
      DayRecord(date: store.todayDate.isEmpty ? _today() : store.todayDate, steps: store.todaySteps),
      ...store.history().where((e) => e.date != store.todayDate),
    ];

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        title: Text(uiLine(lang, 'history')),
        backgroundColor: p.bg,
        foregroundColor: p.ink,
      ),
      body: items.isEmpty
          ? Center(
              child: Text(uiLine(lang, 'noDaysYet'), style: TextStyle(color: p.muted)),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final d = items[i];
                String label;
                try {
                  label = DateFormat.MMMEd(lang).format(DateTime.parse(d.date));
                } catch (_) {
                  label = d.date;
                }
                final isToday = d.date == store.todayDate || i == 0 && d.date == _today();
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: p.card,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          isToday ? '$label  ·  ${uiLine(lang, 'today')}' : label,
                          style: TextStyle(fontSize: 15, color: p.ink),
                        ),
                      ),
                      Text(
                        _fmt(d.steps),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: p.accent,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  String _today() {
    final d = DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String _fmt(int n) => formatCount(n, currentLanguage());
}
