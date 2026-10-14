import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/streak_text.dart';
import '../models/look_pack.dart';
import '../services/postcard.dart';

/// Fixed 1080×1350 (4:5) postcard. Capture with pixelRatio 1.
class PostcardFace extends StatelessWidget {
  const PostcardFace({
    super.key,
    required this.data,
    required this.pack,
    required this.language,
  });

  static const double width = 1080;
  static const double height = 1350;

  final PostcardData data;
  final LookPack pack;
  final String language;

  @override
  Widget build(BuildContext context) {
    final p = pack;
    final lang = language;
    final monthLabel = _monthYear(lang, data.year, data.month);
    final line = postcardClosingLine(lang, data.lineGroup);

    return ColoredBox(
      color: p.bg,
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'Roboto',
          color: p.ink,
        ),
        child: Padding(
        padding: const EdgeInsets.fromLTRB(72, 64, 72, 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icon/icon_foreground.png',
                  width: 56,
                  height: 56,
                  filterQuality: FilterQuality.medium,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.directions_walk,
                    color: p.accent,
                    size: 48,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  postcardUiLine(lang, 'brand').toUpperCase(),
                  style: TextStyle(
                    color: p.muted,
                    fontSize: 22,
                    letterSpacing: 3.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            Text(
              monthLabel,
              style: TextStyle(
                color: p.ink,
                fontSize: 36,
                fontWeight: FontWeight.w500,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              _fmt(data.totalSteps),
              style: TextStyle(
                color: p.accent,
                fontSize: 92,
                fontWeight: FontWeight.w700,
                height: 1,
                letterSpacing: -2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              StreakText.steps(lang, data.totalSteps),
              style: TextStyle(color: p.muted, fontSize: 22),
            ),
            const SizedBox(height: 40),
            _WeekdayRow(language: lang, pack: p),
            const SizedBox(height: 14),
            _CalendarGrid(data: data, pack: p),
            const Spacer(),
            Row(
              children: [
                _stat(StreakText.goodDays(lang, data.goodDays), p),
                _stat(
                  '${postcardUiLine(lang, 'best')}\n${StreakText.steps(lang, data.bestDaySteps)}',
                  p,
                ),
                _stat(postcardWalksLabel(lang, data.walkCount), p),
              ],
            ),
            const SizedBox(height: 36),
            Text(
              line,
              style: TextStyle(
                color: p.ink,
                fontSize: 24,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _stat(String text, LookPack p) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Text(
          text,
          style: TextStyle(
            color: p.muted,
            fontSize: 20,
            height: 1.35,
          ),
        ),
      ),
    );
  }

  String _monthYear(String lang, int year, int month) {
    final d = DateTime(year, month, 1);
    try {
      return DateFormat.yMMMM(lang).format(d);
    } catch (_) {
      return DateFormat.yMMMM('en').format(d);
    }
  }

  String _fmt(int n) {
    return n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow({required this.language, required this.pack});

  final String language;
  final LookPack pack;

  @override
  Widget build(BuildContext context) {
    final monday = DateTime(2026, 10, 5);
    return Row(
      children: [
        for (var i = 0; i < 7; i++)
          Expanded(
            child: Text(
              _label(monday.add(Duration(days: i))),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: pack.muted,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  String _label(DateTime d) {
    try {
      return DateFormat.E(language).format(d);
    } catch (_) {
      return DateFormat.E('en').format(d);
    }
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({required this.data, required this.pack});

  final PostcardData data;
  final LookPack pack;

  @override
  Widget build(BuildContext context) {
    final blanks = data.firstWeekday - 1;
    final cells = <Widget>[
      for (var i = 0; i < blanks; i++) const SizedBox.shrink(),
      for (final d in data.days) _dot(d),
    ];
    final rows = <Widget>[];
    for (var i = 0; i < cells.length; i += 7) {
      final end = i + 7 > cells.length ? cells.length : i + 7;
      final slice = cells.sublist(i, end);
      while (slice.length < 7) {
        slice.add(const SizedBox.shrink());
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            children: [
              for (final c in slice) Expanded(child: Center(child: c)),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _dot(PostcardDay d) {
    switch (d.mark) {
      case PostcardMark.none:
        return const SizedBox(width: 18, height: 18);
      case PostcardMark.gold:
        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: pack.accent,
            shape: BoxShape.circle,
          ),
        );
      case PostcardMark.rest:
        return Icon(
          Icons.nightlight_round,
          size: 20,
          color: pack.accent.withValues(alpha: 0.85),
        );
      case PostcardMark.muted:
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: pack.muted.withValues(alpha: 0.45),
            shape: BoxShape.circle,
          ),
        );
    }
  }
}
