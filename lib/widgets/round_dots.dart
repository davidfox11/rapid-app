import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RoundDots extends StatelessWidget {
  const RoundDots({
    super.key,
    required this.currentRound,
    this.totalRounds = 10,
    this.roundResults = const [],
  });

  final int currentRound;
  final int totalRounds;
  /// Past round outcomes: 'you', 'them', 'draw', or 'none'.
  /// Index 0 = round 1. If shorter than past rounds, falls back to old behavior.
  final List<String> roundResults;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalRounds, (i) {
        final round = i + 1;
        final isPast = round < currentRound;
        final isCurrent = round == currentRound;

        Color color;
        List<BoxShadow>? shadows;

        if (isPast && i < roundResults.length) {
          // Use round result coloring
          switch (roundResults[i]) {
            case 'you':
              color = AppColors.amberGlow;
            case 'them':
              color = AppColors.signalGreen;
            case 'draw':
              color = const Color.fromRGBO(255, 255, 255, 0.15);
            default:
              color = const Color.fromRGBO(255, 255, 255, 0.15);
          }
        } else if (isPast) {
          // Fallback: old behavior — all past rounds amber
          color = AppColors.amberGlow;
        } else if (isCurrent) {
          color = AppColors.amberGlow;
          shadows = [
            BoxShadow(
              color: AppColors.amberGlow.withValues(alpha: 0.4),
              blurRadius: 8,
            ),
          ];
        } else {
          // Future rounds
          color = const Color.fromRGBO(255, 255, 255, 0.08);
        }

        return Padding(
          padding: EdgeInsets.only(left: i > 0 ? 2 : 0),
          child: Container(
            width: 18,
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
              boxShadow: shadows,
            ),
          ),
        );
      }),
    );
  }
}
