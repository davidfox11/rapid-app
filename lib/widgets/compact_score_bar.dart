import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class CompactScoreBar extends StatelessWidget {
  const CompactScoreBar({
    super.key,
    required this.playerAvatar,
    required this.playerScore,
    required this.opponentAvatar,
    required this.opponentScore,
  });

  final Widget playerAvatar;
  final int playerScore;
  final Widget opponentAvatar;
  final int opponentScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.02),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.08),
        ),
      ),
      child: Row(
        children: [
          // Your avatar
          SizedBox(width: 28, height: 28, child: playerAvatar),
          const SizedBox(width: 8),
          // Your score
          Text(
            playerScore.toString(),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.amberGlow,
            ),
          ),
          const SizedBox(width: 10),
          // Tug-of-war bar
          Expanded(
            child: _TugOfWarBar(
              yourScore: playerScore,
              theirScore: opponentScore,
            ),
          ),
          const SizedBox(width: 10),
          // Their score
          Text(
            opponentScore.toString(),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          // Their avatar
          SizedBox(width: 28, height: 28, child: opponentAvatar),
        ],
      ),
    );
  }
}

class _TugOfWarBar extends StatelessWidget {
  const _TugOfWarBar({
    required this.yourScore,
    required this.theirScore,
  });

  final int yourScore;
  final int theirScore;

  @override
  Widget build(BuildContext context) {
    final total = yourScore + theirScore;
    final yourFraction = total > 0 ? yourScore / total : 0.5;

    return SizedBox(
      height: 6,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: yourFraction),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        builder: (context, value, _) {
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0.06),
              borderRadius: BorderRadius.circular(3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Row(
                children: [
                  // Left side (your score) - amber
                  Flexible(
                    flex: (value * 1000).round().clamp(1, 999),
                    child: Container(
                      color: AppColors.amberGlow.withValues(alpha: 0.6),
                    ),
                  ),
                  // Right side (their score) - green
                  Flexible(
                    flex: ((1 - value) * 1000).round().clamp(1, 999),
                    child: Container(
                      color: AppColors.signalGreen.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
