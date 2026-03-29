import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import 'glass_card.dart';

class RoundResultCard extends StatelessWidget {
  const RoundResultCard({
    super.key,
    required this.roundNumber,
    required this.questionText,
    required this.correctAnswer,
    required this.playerResult,
    required this.opponentResult,
    required this.playerCorrect,
    required this.opponentCorrect,
  });

  final int roundNumber;
  final String questionText;
  final String correctAnswer;
  final String playerResult;
  final String opponentResult;
  final bool playerCorrect;
  final bool opponentCorrect;

  @override
  Widget build(BuildContext context) {
    return GlassCardSmall(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: Q{n} + results
          Row(
            children: [
              Text(
                'Q$roundNumber',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.amberGlow,
                ),
              ),
              const Spacer(),
              _ResultBadge(
                label: playerResult,
                isCorrect: playerCorrect,
              ),
              const SizedBox(width: 8),
              _ResultBadge(
                label: opponentResult,
                isCorrect: opponentCorrect,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Question text
          Text(
            questionText,
            style: GoogleFonts.bricolageGrotesque(
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Correct answer
          Text(
            correctAnswer,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              color: AppColors.signalGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.label, required this.isCorrect});

  final String label;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: isCorrect ? AppColors.signalGreen : AppColors.blazeOrange,
      ),
    );
  }
}
