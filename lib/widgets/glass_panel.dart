import 'dart:ui';

import 'package:flutter/material.dart';

/// Solid card with no photo. Frosted glass over a background photo.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.frosted,
    required this.color,
    required this.child,
    this.padding,
    this.radius = 14,
    this.light = false,
  });

  final bool frosted;
  final Color color;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final radiusGeom = BorderRadius.circular(radius);
    if (!frosted) {
      return Container(
        padding: padding,
        decoration: BoxDecoration(color: color, borderRadius: radiusGeom),
        child: child,
      );
    }
    return ClipRRect(
      borderRadius: radiusGeom,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color.withValues(alpha: light ? 0.50 : 0.38),
            borderRadius: radiusGeom,
            border: Border.all(
              color: (light ? Colors.white : Colors.white).withValues(
                alpha: light ? 0.55 : 0.22,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
