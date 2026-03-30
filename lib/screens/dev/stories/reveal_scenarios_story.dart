import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/option_button.dart';
import '../../../widgets/rapid_avatar.dart';

/// Shows all 4 answer reveal combinations with pick tags and point burst pills
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

    final yourPoints = _calcPoints(yourCorrect, yourTimeMs);
    final theirPoints = _calcPoints(theirCorrect, theirTimeMs);
    final bothWrong = !yourCorrect && !theirCorrect;

    // Outcome text
    String outcomeText;
    Color outcomeColor;
    if (yourCorrect && theirCorrect) {
      outcomeText = 'Both correct!';
      outcomeColor = AppColors.signalGreen;
    } else if (bothWrong) {
      outcomeText = 'Both wrong!';
      outcomeColor = AppColors.blazeOrange;
    } else if (yourCorrect) {
      outcomeText = 'You got it!';
      outcomeColor = AppColors.signalGreen;
    } else {
      outcomeText = 'They got it';
      outcomeColor = AppColors.blazeOrange;
    }

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

        // Reveal header with avatars, point burst pills, and outcome
        Row(
          children: [
            // You side
            Expanded(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: yourCorrect
                            ? AppColors.signalGreen
                            : AppColors.blazeOrange,
                        width: 2,
                      ),
                    ),
                    child: const RapidAvatar(defaultAvatarIndex: 1, size: 32),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  _PointBurstPill(
                    points: yourPoints,
                    isFaster: yourTimeMs < theirTimeMs,
                    isCorrect: yourCorrect,
                  ),
                ],
              ),
            ),

            // Center: outcome
            Column(
              children: [
                Text(
                  outcomeText,
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: outcomeColor,
                  ),
                ),
              ],
            ),

            // Opponent side
            Expanded(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theirCorrect
                            ? AppColors.signalGreen
                            : AppColors.blazeOrange,
                        width: 2,
                      ),
                    ),
                    child: const RapidAvatar(defaultAvatarIndex: 6, size: 32),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sarah',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  _PointBurstPill(
                    points: theirPoints,
                    isFaster: theirTimeMs < yourTimeMs,
                    isCorrect: theirCorrect,
                  ),
                ],
              ),
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

        // Options with reveal state + pick tags
        ...List.generate(4, (i) {
          OptionState state;
          final isCorrectOption = i == correctIndex;
          final youPicked = i == yourChoice && yourChoice >= 0;
          final theyPicked = i == theirChoice;

          if (isCorrectOption) {
            state = OptionState.correct;
          } else if (youPicked || theyPicked) {
            state = OptionState.wrong;
          } else {
            state = OptionState.dimmed;
          }

          // Build pick tags as trailing widget
          Widget? trailing;
          if (youPicked || theyPicked) {
            final tags = <Widget>[];
            if (youPicked) {
              tags.add(const _PickTag(label: 'YOU', isYou: true));
            }
            if (theyPicked) {
              tags.add(const _PickTag(label: 'THEM', isYou: false));
            }
            trailing = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                ...tags.map((t) => Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: t,
                    )),
                const SizedBox(width: 6),
                Icon(
                  isCorrectOption ? Icons.check : Icons.close,
                  size: 14,
                  color: isCorrectOption
                      ? AppColors.signalGreen
                      : AppColors.blazeOrange,
                ),
              ],
            );
          } else if (isCorrectOption && bothWrong) {
            trailing = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.signalGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.signalGreen.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'CORRECT',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.signalGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.check,
                  size: 14,
                  color: AppColors.signalGreen,
                ),
              ],
            );
          }

          final opacity = state == OptionState.dimmed
              ? 0.25
              : (isCorrectOption && bothWrong ? 0.7 : 1.0);

          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Opacity(
              opacity: opacity,
              child: OptionButton(
                letter: letters[i],
                text: options[i],
                state: state,
                playerAvatar: trailing,
              ),
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

  int _calcPoints(bool correct, int timeMs) {
    if (!correct) return 0;
    if (timeMs >= 15000) return 0;
    final points = 1000 - (timeMs ~/ 15);
    return points < 100 ? 100 : points;
  }
}

// ─── Point Burst Pill (Storybook version) ──────────────────────

class _PointBurstPill extends StatelessWidget {
  const _PointBurstPill({
    required this.points,
    required this.isFaster,
    required this.isCorrect,
  });

  final int points;
  final bool isFaster;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final isZero = points == 0;
    final Color bgColor;
    final Color borderColor;
    final Color textColor;
    final String label;

    if (isZero) {
      bgColor = const Color.fromRGBO(255, 255, 255, 0.04);
      borderColor = const Color.fromRGBO(255, 255, 255, 0.08);
      textColor = AppColors.textTertiary;
      label = '+0';
    } else {
      bgColor = const Color.fromRGBO(0, 246, 101, 0.12);
      borderColor = AppColors.signalGreen.withValues(alpha: 0.3);
      textColor = AppColors.signalGreen;
      label = isFaster ? '+$points \u26A1' : '+$points';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

// ─── Pick Tag (Storybook version) ──────────────────────────────

class _PickTag extends StatelessWidget {
  const _PickTag({required this.label, required this.isYou});

  final String label;
  final bool isYou;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isYou
            ? const Color.fromRGBO(255, 191, 94, 0.15)
            : const Color.fromRGBO(255, 255, 255, 0.06),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isYou
              ? AppColors.amberGlow.withValues(alpha: 0.3)
              : const Color.fromRGBO(255, 255, 255, 0.12),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: isYou ? AppColors.amberGlow : AppColors.textSecondary,
        ),
      ),
    );
  }
}
