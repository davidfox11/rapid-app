import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class IconCircle extends StatelessWidget {
  const IconCircle({
    super.key,
    required this.child,
    this.size = 40,
    this.onTap,
  });

  final Widget child;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.glassPanel,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.glassStroke),
      ),
      child: Center(child: child),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: circle);
    }
    return circle;
  }
}
