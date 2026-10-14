import 'dart:math' as math;

import 'package:flutter/material.dart';

class StepRing extends StatelessWidget {
  const StepRing({
    super.key,
    required this.steps,
    required this.goal,
    required this.track,
    required this.accent,
    required this.child,
  });

  final int steps;
  final int goal;
  final Color track;
  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = goal <= 0 ? 0.0 : (steps / goal).clamp(0.0, 1.0);
    return SizedBox(
      width: 260,
      height: 260,
      child: CustomPaint(
        painter: _RingPainter(t, track, accent),
        child: Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.t, this.track, this.accent);
  final double t;
  final Color track;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 10;
    final bg = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    final fg = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(c, r, bg);
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -math.pi / 2,
      t * math.pi * 2,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.t != t || old.track != track || old.accent != accent;
}
