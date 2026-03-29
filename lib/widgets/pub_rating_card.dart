import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import 'data_label.dart';
import 'glass_card.dart';

class PubRatingCard extends StatelessWidget {
  const PubRatingCard({
    super.key,
    required this.rating,
    required this.weeklyDelta,
  });

  final int rating;
  final int weeklyDelta;

  @override
  Widget build(BuildContext context) {
    final isPositive = weeklyDelta >= 0;
    final arrow = isPositive ? '▲' : '▼';
    final deltaColor =
        isPositive ? AppColors.signalGreen : AppColors.blazeOrange;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DataLabel('Pub Rating'),
          const SizedBox(height: 8),
          Text(
            rating.toString(),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: AppColors.amberGlow,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$arrow ${weeklyDelta.abs()} this week',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: deltaColor,
            ),
          ),
        ],
      ),
    );
  }
}
