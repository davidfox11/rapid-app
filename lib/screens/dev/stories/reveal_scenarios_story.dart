import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/data_label.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/option_button.dart';
import '../../../widgets/rapid_avatar.dart';

/// Shows all 4 answer reveal combinations
class RevealScenariosStory extends StatelessWidget {
  const RevealScenariosStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ScenarioBlock(
            title: 'Both Correct (you faster)',
            yourChoice: 1,
            yourCorrect: true,
            yourTimeMs: 1200,
            theirChoice: 1,
            theirCorrect: true,
            theirTimeMs: 3400,
            correctIndex: 1,
          ),
          SizedBox(height: 32),
          _ScenarioBlock(
            title: 'You Right, They Wrong',
            yourChoice: 1,
            yourCorrect: true,
            yourTimeMs: 2100,
            theirChoice: 0,
            theirCorrect: false,
            theirTimeMs: 4200,
            correctIndex: 1,
          ),
          SizedBox(height: 32),
          _ScenarioBlock(
            title: 'You Wrong, They Right',
            yourChoice: 2,
            yourCorrect: false,
            yourTimeMs: 5100,
            theirChoice: 1,
            theirCorrect: true,
            theirTimeMs: 2000,
            correctIndex: 1,
          ),
          SizedBox(height: 32),
          _ScenarioBlock(
            title: 'Both Wrong',
            yourChoice: 0,
            yourCorrect: false,
            yourTimeMs: 4500,
            theirChoice: 3,
            theirCorrect: false,
            theirTimeMs: 6200,
            correctIndex: 1,
          ),
          SizedBox(height: 32),
          _ScenarioBlock(
            title: 'You Timeout, They Right',
            yourChoice: -1,
            yourCorrect: false,
            yourTimeMs: 15000,
            theirChoice: 1,
            theirCorrect: true,
            theirTimeMs: 3000,
            correctIndex: 1,
          ),
        ],
      ),
    );
  }
}

class _ScenarioBlock extends StatelessWidget {
  const _ScenarioBlock({
    required this.title,
    required this.yourChoice,
    required this.yourCorrect,
    required this.yourTimeMs,
    required this.theirChoice,
    required this.theirCorrect,
    required this.theirTimeMs,
    required this.correctIndex,
  });

  final String title;
  final int yourChoice;
  final bool yourCorrect;
  final int yourTimeMs;
  final int theirChoice;
  final bool theirCorrect;
  final int theirTimeMs;
  final int correctIndex;

  @override
  Widget build(BuildContext context) {
    const options = ['Atlantic Ocean', 'Pacific Ocean', 'Indian Ocean', 'Arctic Ocean'];
    const letters = ['A', 'B', 'C', 'D'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scenario header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.amberDim,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.amberGlow,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Score delta row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const RapidAvatar(defaultAvatarIndex: 1, size: 32),
                const SizedBox(height: 4),
                Text(
                  yourCorrect ? '+${_calcPoints(yourTimeMs)}' : '+0',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: yourCorrect
                        ? AppColors.signalGreen
                        : AppColors.blazeOrange,
                  ),
                ),
              ],
            ),
            DataLabel(yourCorrect ? 'Correct' : 'Wrong'),
            Column(
              children: [
                const RapidAvatar(defaultAvatarIndex: 6, size: 32),
                const SizedBox(height: 4),
                Text(
                  theirCorrect ? '+${_calcPoints(theirTimeMs)}' : '+0',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: theirCorrect
                        ? AppColors.signalGreen
                        : AppColors.blazeOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Question
        GlassCardSmall(
          child: Column(
            children: [
              Text(
                'What is the largest ocean on Earth?',
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Correct: ${options[correctIndex]}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: AppColors.amberGlow,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Options with reveal state
        ...List.generate(4, (i) {
          OptionState state;
          Widget? playerAv;
          Widget? opponentAv;

          if (i == correctIndex) {
            state = OptionState.correct;
          } else if (i == yourChoice || i == theirChoice) {
            state = OptionState.wrong;
          } else {
            state = OptionState.dimmed;
          }

          if (i == yourChoice && yourChoice >= 0) {
            playerAv = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const RapidAvatar(defaultAvatarIndex: 1, size: 16),
                const SizedBox(width: 3),
                Text(
                  yourCorrect ? '\u2713' : '\u2717',
                  style: TextStyle(
                    fontSize: 12,
                    color: yourCorrect
                        ? AppColors.signalGreen
                        : AppColors.blazeOrange,
                  ),
                ),
              ],
            );
          }
          if (i == theirChoice) {
            opponentAv = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const RapidAvatar(defaultAvatarIndex: 6, size: 16),
                const SizedBox(width: 3),
                Text(
                  theirCorrect ? '\u2713' : '\u2717',
                  style: TextStyle(
                    fontSize: 12,
                    color: theirCorrect
                        ? AppColors.signalGreen
                        : AppColors.blazeOrange,
                  ),
                ),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: OptionButton(
              letter: letters[i],
              text: options[i],
              state: state,
              playerAvatar: playerAv,
              opponentAvatar: opponentAv,
            ),
          );
        }),

        // Speed comparison
        const SizedBox(height: 6),
        GlassCardSmall(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                yourChoice >= 0
                    ? 'You: ${(yourTimeMs / 1000).toStringAsFixed(1)}s'
                    : 'You: timeout',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: yourTimeMs < theirTimeMs
                      ? AppColors.signalGreen
                      : AppColors.textSecondary,
                ),
              ),
              Text(
                'Them: ${(theirTimeMs / 1000).toStringAsFixed(1)}s',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: theirTimeMs < yourTimeMs
                      ? AppColors.signalGreen
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  int _calcPoints(int timeMs) {
    if (timeMs >= 15000) return 0;
    final points = 1000 - (timeMs ~/ 15);
    return points < 100 ? 100 : points;
  }
}
