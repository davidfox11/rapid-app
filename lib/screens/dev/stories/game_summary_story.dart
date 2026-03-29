import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/data_label.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/rapid_avatar.dart';
import '../../../widgets/round_result_card.dart';

/// Victory / Defeat / Draw variants of the game summary header
class GameSummaryStory extends StatelessWidget {
  const GameSummaryStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          _SummaryVariant(
            result: 'VICTORY',
            subtitle: 'You dominated the pub!',
            yourScore: 6800,
            theirScore: 5200,
            ratingChange: 18,
            isWin: true,
          ),
          SizedBox(height: 32),
          _SummaryVariant(
            result: 'DEFEAT',
            subtitle: 'A tough loss.',
            yourScore: 4100,
            theirScore: 5900,
            ratingChange: -12,
            isWin: false,
          ),
          SizedBox(height: 32),
          _SummaryVariant(
            result: 'DRAW',
            subtitle: 'Evenly matched!',
            yourScore: 5500,
            theirScore: 5500,
            ratingChange: 0,
            isWin: false,
          ),
          SizedBox(height: 32),
          DataLabel('Sample Round Cards'),
          SizedBox(height: 12),
          RoundResultCard(
            roundNumber: 1,
            questionText: 'What is the chemical symbol for gold?',
            correctAnswer: 'Au',
            playerResult: '\u2713 1.2s',
            opponentResult: '\u2717 3.4s',
            playerCorrect: true,
            opponentCorrect: false,
          ),
          SizedBox(height: 8),
          RoundResultCard(
            roundNumber: 2,
            questionText: 'Who directed "Inception"?',
            correctAnswer: 'Christopher Nolan',
            playerResult: '\u2717 5.1s',
            opponentResult: '\u2713 2.0s',
            playerCorrect: false,
            opponentCorrect: true,
          ),
          SizedBox(height: 8),
          RoundResultCard(
            roundNumber: 3,
            questionText: 'What is the capital of New Zealand?',
            correctAnswer: 'Wellington',
            playerResult: '\u2014 timeout',
            opponentResult: '\u2713 3.2s',
            playerCorrect: false,
            opponentCorrect: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryVariant extends StatelessWidget {
  const _SummaryVariant({
    required this.result,
    required this.subtitle,
    required this.yourScore,
    required this.theirScore,
    required this.ratingChange,
    required this.isWin,
  });

  final String result;
  final String subtitle;
  final int yourScore;
  final int theirScore;
  final int ratingChange;
  final bool isWin;

  @override
  Widget build(BuildContext context) {
    final isDraw = ratingChange == 0;

    return GlassCard(
      child: Column(
        children: [
          Text(
            'MATCH COMPLETE',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
              color: AppColors.amberGlow,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            result,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 32,
              color: isWin ? AppColors.amberGlow : AppColors.textSecondary,
              shadows: isWin
                  ? [
                      const Shadow(
                        color: Color.fromRGBO(255, 191, 94, 0.3),
                        blurRadius: 30,
                      ),
                    ]
                  : null,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.bricolageGrotesque(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const RapidAvatar(defaultAvatarIndex: 1, size: 36),
              const SizedBox(width: 12),
              Text(
                '$yourScore',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isWin || isDraw
                      ? AppColors.signalGreen
                      : AppColors.textSecondary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text('-',
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 14, color: AppColors.textTertiary)),
              ),
              Text(
                '$theirScore',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: !isWin && !isDraw
                      ? AppColors.signalGreen
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              const RapidAvatar(defaultAvatarIndex: 6, size: 36),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${ratingChange >= 0 ? "+" : ""}$ratingChange rating',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: ratingChange >= 0
                  ? AppColors.signalGreen
                  : AppColors.blazeOrange,
            ),
          ),
        ],
      ),
    );
  }
}
