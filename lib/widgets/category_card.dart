import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.iconPath,
    required this.name,
    required this.description,
    required this.questionCount,
    this.isSelected = false,
    this.onTap,
  });

  final String iconPath;
  final String name;
  final String description;
  final int questionCount;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? const Color.fromRGBO(255, 191, 94, 0.4)
        : AppColors.glassStroke;

    final content = Row(
      children: [
        // Icon box
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.02),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassStroke),
          ),
          child: Center(
            child: SvgPicture.asset(iconPath, width: 24, height: 24),
          ),
        ),
        const SizedBox(width: 16),
        // Text column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Question count
        Text(
          '$questionCount Qs',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );

    // Use IntrinsicHeight + Row for the left accent strip approach
    final card = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.amberDim : AppColors.glassPanel,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              if (isSelected)
                Container(width: 4, color: AppColors.amberGlow),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      isSelected ? 14 : 18, 18, 18, 18),
                  child: content,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}
