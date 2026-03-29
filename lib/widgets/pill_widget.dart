import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

enum PillVariant { green, amber, glass }

class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    this.variant = PillVariant.glass,
    this.icon,
  });

  final String label;
  final PillVariant variant;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color borderColor;
    final Color textColor;

    switch (variant) {
      case PillVariant.green:
        bg = AppColors.greenDim;
        borderColor = const Color.fromRGBO(0, 246, 101, 0.2);
        textColor = AppColors.signalGreen;
      case PillVariant.amber:
        bg = AppColors.amberDim;
        borderColor = const Color.fromRGBO(255, 191, 94, 0.2);
        textColor = AppColors.amberGlow;
      case PillVariant.glass:
        bg = AppColors.glassPanel;
        borderColor = AppColors.glassStroke;
        textColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            SizedBox(width: 12, height: 12, child: icon),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
