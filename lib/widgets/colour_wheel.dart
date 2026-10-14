import 'dart:math' as math;

import 'package:flutter/material.dart';

/// HSV colour circle: hue around the wheel, saturation toward the edge,
/// brightness on the slider underneath.
class ColourWheel extends StatefulWidget {
  const ColourWheel({
    super.key,
    required this.color,
    required this.onChanged,
  });

  final Color color;
  final ValueChanged<Color> onChanged;

  @override
  State<ColourWheel> createState() => _ColourWheelState();
}

class _ColourWheelState extends State<ColourWheel> {
  late HSVColor _hsv;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.color);
  }

  void _emit(HSVColor next) {
    setState(() => _hsv = next);
    widget.onChanged(next.toColor());
  }

  void _pick(Offset local, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide / 2;
    final d = local - c;
    final sat = (d.distance / r).clamp(0.0, 1.0);
    var hue = math.atan2(d.dy, d.dx) * 180 / math.pi;
    if (hue < 0) hue += 360;
    _emit(_hsv.withHue(hue).withSaturation(sat));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LayoutBuilder(
          builder: (context, box) {
            final side = math.min(box.maxWidth, 280.0);
            return Center(
              child: SizedBox(
                width: side,
                height: side,
                child: GestureDetector(
                  onPanDown: (d) => _pick(d.localPosition, Size(side, side)),
                  onPanUpdate: (d) => _pick(d.localPosition, Size(side, side)),
                  child: CustomPaint(
                    painter: _WheelPainter(_hsv),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Icon(Icons.dark_mode_outlined, size: 18, color: Colors.grey.shade500),
            Expanded(
              child: Slider(
                value: _hsv.value,
                activeColor: _hsv.toColor(),
                onChanged: (v) => _emit(_hsv.withValue(v)),
              ),
            ),
            Icon(Icons.light_mode_outlined, size: 18, color: Colors.grey.shade500),
          ],
        ),
      ],
    );
  }
}

class _WheelPainter extends CustomPainter {
  _WheelPainter(this.hsv);
  final HSVColor hsv;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide / 2 - 2;
    final rect = Rect.fromCircle(center: c, radius: r);

    final hues = <Color>[
      for (var i = 0; i <= 12; i++)
        HSVColor.fromAHSV(1, (i * 30) % 360.0, 1, 1).toColor(),
    ];
    canvas.drawCircle(
      c,
      r,
      Paint()..shader = SweepGradient(colors: hues).createShader(rect),
    );
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = RadialGradient(
          colors: [
            HSVColor.fromAHSV(1, 0, 0, hsv.value).toColor(),
            const Color(0x00000000),
          ],
        ).createShader(rect),
    );
    if (hsv.value < 1) {
      canvas.drawCircle(
        c,
        r,
        Paint()..color = Colors.black.withValues(alpha: 1 - hsv.value),
      );
    }

    final angle = hsv.hue * math.pi / 180;
    final thumb = Offset(
      c.dx + math.cos(angle) * hsv.saturation * r,
      c.dy + math.sin(angle) * hsv.saturation * r,
    );
    canvas.drawCircle(thumb, 15, Paint()..color = Colors.white);
    canvas.drawCircle(thumb, 12, Paint()..color = hsv.toColor());
  }

  @override
  bool shouldRepaint(covariant _WheelPainter old) => old.hsv != hsv;
}
