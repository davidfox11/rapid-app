import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Transforms a circular RadialGradient into an ellipse by scaling axes.
class _EllipticalTransform extends GradientTransform {
  const _EllipticalTransform(this.scaleX, this.scaleY);

  final double scaleX;
  final double scaleY;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final cx = bounds.center.dx;
    final cy = bounds.center.dy;
    return Matrix4.identity()
      ..translateByDouble(cx, cy, 0, 1.0)
      ..scaleByDouble(1.0 / scaleX, 1.0 / scaleY, 1.0, 1.0)
      ..translateByDouble(-cx, -cy, 0, 1.0);
  }
}

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base fill
        Container(color: AppColors.bgDeep),

        // Overlay 1: large plum glow from top-center (ellipse 120% 50%)
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 0.85,
              transform: _EllipticalTransform(1.2, 0.5),
              colors: [Color.fromRGBO(42, 20, 56, 0.7), Colors.transparent],
            ),
          ),
        ),

        // Overlay 2: secondary plum from top-left (ellipse 80% 30%)
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.6, -0.8),
              radius: 0.55,
              transform: _EllipticalTransform(0.8, 0.3),
              colors: [Color.fromRGBO(60, 20, 40, 0.3), Colors.transparent],
            ),
          ),
        ),

        // Overlay 3: faint amber highlight from top-right (ellipse 60% 40%)
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.6, -0.9),
              radius: 0.5,
              transform: _EllipticalTransform(0.6, 0.4),
              colors: [Color.fromRGBO(255, 191, 94, 0.03), Colors.transparent],
            ),
          ),
        ),

        // Child content
        child,
      ],
    );
  }
}
