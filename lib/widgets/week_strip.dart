import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/streak_text.dart';
import '../models/look_pack.dart';
import '../services/step_math.dart';
import '../services/streaks.dart';
import 'glass_panel.dart';

class WeekStrip extends StatefulWidget {
  const WeekStrip({
    super.key,
    required this.stepsByDate,
    required this.goal,
    required this.now,
    required this.language,
    required this.pack,
    required this.fontScale,
    required this.frosted,
  });

  final Map<String, int> stepsByDate;
  final int goal;
  final DateTime now;
  final String language;
  final LookPack pack;
  final double fontScale;
  final bool frosted;

  @override
  State<WeekStrip> createState() => _WeekStripState();
}

class _WeekStripState extends State<WeekStrip> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final streak = computeStreak(
      stepsByDate: widget.stepsByDate,
      goal: widget.goal,
      now: widget.now,
    );
    final days = weekView(
      stepsByDate: widget.stepsByDate,
      goal: widget.goal,
      now: widget.now,
      restDates: streak.restDates,
    );
    final today = todayKey(widget.now);
    final selectedKey = _selected ?? today;
    final selected = days.firstWhere(
      (d) => d.key == selectedKey,
      orElse: () => days.firstWhere(
        (d) => d.isToday,
        orElse: () => days.last,
      ),
    );

    final p = widget.pack;
    final lang = widget.language;
    final streakLine = streak.freshStart
        ? StreakText.freshStart(lang)
        : StreakText.goodDays(lang, streak.goodDays);

    String caption = StreakText.steps(lang, selected.steps);
    if (selected.isRest) {
      caption = '${StreakText.restDay(lang)} · $caption';
    }

    return GlassPanel(
      frosted: widget.frosted,
      color: p.card,
      light: p.light,
      radius: 16,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StreakText.thisWeek(lang),
            style: TextStyle(
              color: p.muted,
              fontSize: 12 * widget.fontScale,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            streakLine,
            style: TextStyle(
              color: p.ink,
              fontSize: 15 * widget.fontScale,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final d in days)
                Expanded(
                  child: _DayCell(
                    day: d,
                    selected: d.key == selected.key,
                    pack: p,
                    language: lang,
                    goal: widget.goal,
                    onTap: () => setState(() => _selected = d.key),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            caption,
            style: TextStyle(
              color: p.muted,
              fontSize: 13 * widget.fontScale,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.pack,
    required this.language,
    required this.goal,
    required this.onTap,
  });

  final WeekDayInfo day;
  final bool selected;
  final LookPack pack;
  final String language;
  final int goal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    String label;
    try {
      label = DateFormat.E(language).format(day.date);
    } catch (_) {
      label = DateFormat.E('en').format(day.date);
    }

    final maxH = 32.0;
    final t = goal <= 0
        ? 0.0
        : (day.steps / goal).clamp(0.0, 1.0).toDouble();
    final barH = day.isFuture
        ? 3.0
        : day.steps <= 0
            ? 3.0
            : (6.0 + t * (maxH - 6.0));
    final inProgressToday = day.isToday && !day.metGoal && !day.isFuture;
    final barColor = day.metGoal
        ? pack.accent
        : inProgressToday
            ? pack.accent.withValues(alpha: 0.55)
            : pack.muted.withValues(alpha: day.isFuture ? 0.28 : 0.55);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: day.isToday || selected ? pack.ink : pack.muted,
                fontSize: 11,
                fontWeight: day.isToday ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 8,
              child: day.isToday
                  ? Center(
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: pack.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            Container(
              key: ValueKey('week-cell-${day.key}'),
              height: maxH + 10,
              decoration: selected
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: pack.accent.withValues(alpha: 0.75),
                        width: 1.2,
                      ),
                    )
                  : null,
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 5, top: 4),
              child: day.isRest
                  ? Icon(
                      Icons.nightlight_round,
                      size: 16,
                      color: pack.accent.withValues(alpha: 0.85),
                    )
                  : Container(
                      key: day.isToday
                          ? const ValueKey('week-today-bar')
                          : null,
                      width: 8,
                      height: barH,
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
