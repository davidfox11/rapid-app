import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RoundDots extends StatelessWidget {
  const RoundDots({
    super.key,
    required this.currentRound,
    this.totalRounds = 10,
  });

  final int currentRound;
  final int totalRounds;

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

        if (isPast || isCurrent) {
          color = AppColors.amberGlow;
          shadows = isCurrent
              ? [
                  BoxShadow(
                    color: AppColors.amberGlow.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ]
              : null;
        } else {
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
