import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import 'data_label.dart';

class ScoreBar extends StatelessWidget {
  const ScoreBar({
    super.key,
    required this.playerAvatar,
    required this.playerScore,
    required this.opponentAvatar,
    required this.opponentScore,
    required this.categoryLabel,
  });

  final Widget playerAvatar;
  final int playerScore;
  final Widget opponentAvatar;
  final int opponentScore;
  final String categoryLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Player side
        playerAvatar,
        const SizedBox(width: 8),
        Text(
          playerScore.toString(),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.amberGlow,
          ),
        ),

        // Center category
        Expanded(
          child: Center(
            child: DataLabel(categoryLabel),
          ),
        ),

        // Opponent side
        Text(
          opponentScore.toString(),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.amberGlow,
          ),
        ),
        const SizedBox(width: 8),
        opponentAvatar,
      ],
    );
  }
}
