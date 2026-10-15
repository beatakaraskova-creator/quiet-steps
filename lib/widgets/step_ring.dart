import 'dart:math' as math;

import 'package:flutter/material.dart';

class StepRing extends StatefulWidget {
  const StepRing({
    super.key,
    required this.steps,
    required this.goal,
    required this.track,
    required this.accent,
    required this.child,
    this.size = 260,
    this.strokeWidth = 12,
  });

  final int steps;
  final int goal;
  final Color track;
  final Color accent;
  final Widget child;
  final double size;
  final double strokeWidth;

  static const milestones = [2500, 5000, 7500];

  @override
  State<StepRing> createState() => _StepRingState();
}

class _StepRingState extends State<StepRing> with TickerProviderStateMixin {
  late final AnimationController _fill;
  late final AnimationController _delight;
  bool _ready = false;
  bool _celebrating = false;

  bool get _reduceMotion {
    final mq = MediaQuery.maybeOf(context);
    return mq?.disableAnimations ?? false;
  }

  double get _target {
    final goal = widget.goal;
    if (goal <= 0) return 0;
    return (widget.steps / goal).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _fill = AnimationController(vsync: this, duration: const Duration(milliseconds: 850));
    _delight = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ready) return;
    _ready = true;
    _goTo(_target, fromZero: true);
  }

  @override
  void didUpdateWidget(covariant StepRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.steps != widget.steps || oldWidget.goal != widget.goal) {
      _goTo(_target);
      _maybeDelight(oldWidget.steps, widget.steps, widget.goal);
    }
  }

  void _goTo(double target, {bool fromZero = false}) {
    if (_reduceMotion) {
      _fill.value = target;
      return;
    }
    if (fromZero) {
      _fill.value = 0;
    }
    _fill.animateTo(
      target,
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeOutCubic,
    );
  }

  void _maybeDelight(int from, int to, int goal) {
    if (from == to) return;
    if (goal > 0 && from < goal && to >= goal) {
      _startCelebrate();
      return;
    }
    for (final m in StepRing.milestones) {
      if (goal > 0 && m >= goal) continue;
      if (from < m && to >= m) {
        _startPulse();
        return;
      }
    }
  }

  Future<void> _startPulse() async {
    if (_reduceMotion || !mounted) return;
    _celebrating = false;
    _delight.duration = const Duration(milliseconds: 1100);
    await _delight.forward(from: 0);
    if (mounted) _delight.value = 0;
  }

  Future<void> _startCelebrate() async {
    if (_reduceMotion || !mounted) return;
    setState(() => _celebrating = true);
    _delight.duration = const Duration(milliseconds: 1800);
    await _delight.forward(from: 0);
    if (!mounted) return;
    setState(() => _celebrating = false);
    _delight.value = 0;
  }

  @override
  void dispose() {
    _fill.dispose();
    _delight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_fill, _delight]),
        builder: (context, child) {
          final glow = _celebrating
              ? (1.0 - Curves.easeIn.transform((_delight.value - 0.55).clamp(0.0, 1.0) / 0.45))
              : math.sin(_delight.value * math.pi);
          return CustomPaint(
            painter: _RingPainter(
              t: _fill.value.clamp(0.0, 1.0),
              track: widget.track,
              accent: widget.accent,
              strokeWidth: widget.strokeWidth,
              glow: glow.clamp(0.0, 1.0),
            ),
            foregroundPainter: _celebrating
                ? _ParticlesPainter(
                    progress: _delight.value,
                    color: widget.accent,
                    strokeWidth: widget.strokeWidth,
                  )
                : null,
            child: child,
          );
        },
        child: Center(child: widget.child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.t,
    required this.track,
    required this.accent,
    required this.strokeWidth,
    required this.glow,
  });

  final double t;
  final Color track;
  final Color accent;
  final double strokeWidth;
  final double glow;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - strokeWidth;
    final bg = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final fg = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(c, r, bg);

    if (glow > 0.01) {
      final g = Paint()
        ..color = accent.withValues(alpha: 0.28 * glow)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 14 * glow
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6 + 10 * glow);
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        -math.pi / 2,
        t * math.pi * 2,
        false,
        g,
      );
    }

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
      old.t != t ||
      old.track != track ||
      old.accent != accent ||
      old.strokeWidth != strokeWidth ||
      old.glow != glow;
}

class _ParticlesPainter extends CustomPainter {
  _ParticlesPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - strokeWidth;
    final rnd = math.Random(7);
    final fade = (1.0 - progress).clamp(0.0, 1.0);
    for (var i = 0; i < 8; i++) {
      final angle = -math.pi / 2 + rnd.nextDouble() * math.pi * 2;
      final dist = r * (0.70 + 0.20 * rnd.nextDouble());
      final rise = 22.0 * progress * (0.55 + rnd.nextDouble() * 0.45);
      final pos = Offset(
        c.dx + math.cos(angle) * dist,
        c.dy + math.sin(angle) * dist - rise,
      );
      final radius = 2.0 + rnd.nextDouble() * 2.2;
      canvas.drawCircle(
        pos,
        radius,
        Paint()..color = color.withValues(alpha: 0.55 * fade),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter old) =>
      old.progress != progress || old.color != color;
}
