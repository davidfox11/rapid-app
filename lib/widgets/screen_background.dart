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
    return DefaultTextStyle(
      style: const TextStyle(
        decoration: TextDecoration.none,
        color: AppColors.textPrimary,
      ),
      child: Stack(
        children: [
          // Base fill — deep indigo-purple, not pure black
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A1530), // warm purple at top
                  Color(0xFF110E20), // deeper purple-black
                  Color(0xFF0D0B18), // near-black at bottom
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Overlay 1: large plum glow from top-center — stronger
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 0.85,
                transform: _EllipticalTransform(1.2, 0.5),
                colors: [
                  Color.fromRGBO(55, 30, 80, 0.8),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Overlay 2: secondary plum from top-left
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.6, -0.8),
                radius: 0.55,
                transform: _EllipticalTransform(0.8, 0.3),
                colors: [
                  Color.fromRGBO(70, 25, 55, 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Overlay 3: subtle warm amber at center-top
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.3),
                radius: 0.6,
                colors: [
                  Color.fromRGBO(255, 191, 94, 0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Overlay 4: very subtle blue-purple edge lighting
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.8, -0.9),
                radius: 0.5,
                colors: [
                  Color.fromRGBO(80, 60, 140, 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Child content
          child,
        ],
      ),
    );
  }
}
