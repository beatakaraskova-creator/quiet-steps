import 'dart:math' as math;

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
    final card = Color.lerp(p.card, p.ink, p.light ? 0.04 : 0.06)!;
    final border = Color.lerp(card, p.ink, p.light ? 0.14 : 0.16)!;

    return ColoredBox(
      color: p.bg,
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'Roboto',
          color: p.ink,
        ),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(48),
              border: Border.all(color: border, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(56, 48, 56, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icon/icon_foreground.png',
                        width: 240,
                        height: 240,
                        filterQuality: FilterQuality.medium,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.directions_walk,
                          color: p.accent,
                          size: 200,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Text(
                        postcardUiLine(lang, 'brand').toUpperCase(),
                        style: TextStyle(
                          color: p.muted,
                          fontSize: 28,
                          letterSpacing: 3.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    monthLabel,
                    style: TextStyle(
                      color: p.ink,
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _fmt(data.totalSteps),
                    key: const ValueKey('postcard-total'),
                    style: TextStyle(
                      color: p.accent,
                      fontSize: 88,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    StreakText.stepsWord(lang, data.totalSteps),
                    key: const ValueKey('postcard-steps-word'),
                    style: TextStyle(color: p.muted, fontSize: 28),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    key: const ValueKey('postcard-calendar'),
                    child: Column(
                      children: [
                        _WeekdayRow(language: lang, pack: p),
                        const SizedBox(height: 12),
                        Expanded(
                          child: _CalendarGrid(data: data, pack: p),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    key: const ValueKey('postcard-stats'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _stat(StreakText.goodDays(lang, data.goodDays), p),
                      _stat(
                        '${postcardUiLine(lang, 'best')}\n${StreakText.steps(lang, data.bestDaySteps)}',
                        p,
                      ),
                      _stat(postcardWalksLabel(lang, data.walkCount), p),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    line,
                    style: TextStyle(
                      color: p.ink,
                      fontSize: 40,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stat(String text, LookPack p) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Text(
          text,
          style: TextStyle(
            color: p.muted,
            fontSize: 42,
            height: 1.3,
          ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
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
    try {
      return NumberFormat.decimalPattern(language).format(n);
    } catch (_) {
      return NumberFormat.decimalPattern('en').format(n);
    }
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
                fontSize: 22,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final blanks = data.firstWeekday - 1;
        final totalCells = blanks + data.days.length;
        final rowCount = (totalCells / 7).ceil().clamp(1, 6);
        final rowH = constraints.maxHeight / rowCount;
        final colW = constraints.maxWidth / 7;
        final mark = (math.min(rowH, colW) * 0.58).clamp(26.0, 44.0);

        final cells = <Widget>[
          for (var i = 0; i < blanks; i++) const SizedBox.shrink(),
          for (final d in data.days) _dot(d, mark),
        ];
        final rows = <Widget>[];
        for (var i = 0; i < cells.length; i += 7) {
          final end = i + 7 > cells.length ? cells.length : i + 7;
          final slice = cells.sublist(i, end);
          while (slice.length < 7) {
            slice.add(const SizedBox.shrink());
          }
          rows.add(
            Expanded(
              child: Row(
                children: [
                  for (final c in slice) Expanded(child: Center(child: c)),
                ],
              ),
            ),
          );
        }
        return Column(children: rows);
      },
    );
  }

  Widget _dot(PostcardDay d, double size) {
    switch (d.mark) {
      case PostcardMark.none:
        return SizedBox(width: size, height: size);
      case PostcardMark.gold:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: pack.accent,
            shape: BoxShape.circle,
          ),
        );
      case PostcardMark.rest:
        return Icon(
          Icons.nightlight_round,
          size: size + 4,
          color: pack.accent.withValues(alpha: 0.85),
        );
      case PostcardMark.muted:
        return Container(
          width: size * 0.78,
          height: size * 0.78,
          decoration: BoxDecoration(
            color: pack.muted.withValues(alpha: 0.45),
            shape: BoxShape.circle,
          ),
        );
    }
  }
}
