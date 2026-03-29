import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../data/mock_data.dart';
import '../../providers/auth_provider.dart';
import '../../providers/game_provider.dart';
import '../../widgets/clay_button.dart';
import '../../widgets/data_label.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/home_indicator.dart';
import '../../widgets/rapid_avatar.dart';
import '../../widgets/round_result_card.dart';
import '../../widgets/screen_background.dart';

class GameSummaryScreen extends ConsumerStatefulWidget {
  const GameSummaryScreen({super.key});

  @override
  ConsumerState<GameSummaryScreen> createState() => _GameSummaryScreenState();
}

class _GameSummaryScreenState extends ConsumerState<GameSummaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scoreAnim;
  late Animation<double> _scoreProgress;

  @override
  void initState() {
    super.initState();
    _scoreAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scoreProgress = CurvedAnimation(
      parent: _scoreAnim,
      curve: Curves.easeOut,
    );
    // Start count-up after brief delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _scoreAnim.forward();
    });
  }

  @override
  void dispose() {
    _scoreAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameProvider);
    final user = ref.watch(currentUserProvider);

    if (game == null) {
      return ScreenBackground(
        child: Center(
          child: Text('No game data', style: AppTypography.serifH(fontSize: 24)),
        ),
      );
    }

    final yourScore = game.yourScore;
    final theirScore = game.theirScore;
    final isWin = yourScore > theirScore;
    final isDraw = yourScore == theirScore;
    final ratingChange = isWin ? 18 : (isDraw ? 0 : -12);

    // Count correct rounds from mock data
    const rounds = MockData.mockMatchRounds;
    final yourCorrectCount = rounds.where((r) => r.yourCorrect).length;
    final avgSpeedMs = rounds
            .where((r) => r.yourCorrect)
            .fold<int>(0, (sum, r) => sum + r.yourTimeMs) /
        max(1, yourCorrectCount);

    return ScreenBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      // Header
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
                        isWin ? 'VICTORY' : (isDraw ? 'DRAW' : 'DEFEAT'),
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 40,
                          color: isWin ? AppColors.amberGlow : AppColors.textSecondary,
                          shadows: isWin
                              ? [
                                  const Shadow(
                                    color: Color.fromRGBO(255, 191, 94, 0.3),
                                    blurRadius: 40,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isWin
                            ? 'You dominated the pub!'
                            : (isDraw ? 'Evenly matched!' : 'A tough loss.'),
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Score section with count-up
                      AnimatedBuilder(
                        animation: _scoreProgress,
                        builder: (context, _) {
                          final yourAnimated =
                              (yourScore * _scoreProgress.value).round();
                          final theirAnimated =
                              (theirScore * _scoreProgress.value).round();
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  RapidAvatar(
                                    avatarUrl: user.avatarUrl,
                                    defaultAvatarIndex: user.defaultAvatarIndex,
                                    size: 42,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'You',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 9,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '$yourAnimated',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: isWin || isDraw
                                      ? AppColors.signalGreen
                                      : AppColors.textSecondary,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  '-',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 16,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ),
                              Text(
                                '$theirAnimated',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: !isWin && !isDraw
                                      ? AppColors.signalGreen
                                      : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                children: [
                                  RapidAvatar(
                                    avatarUrl: game.opponentAvatarUrl,
                                    defaultAvatarIndex:
                                        game.opponentDefaultAvatarIndex,
                                    size: 42,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    game.opponentName,
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 9,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),

                      // Rating change
                      const SizedBox(height: 8),
                      Text(
                        '${ratingChange >= 0 ? "+" : ""}$ratingChange rating',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: ratingChange >= 0
                              ? AppColors.signalGreen
                              : AppColors.blazeOrange,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Stats grid
                      Row(
                        children: [
                          Expanded(
                            child: GlassCardSmall(
                              child: Column(
                                children: [
                                  const DataLabel('Accuracy'),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${(yourCorrectCount * 10)}%',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '($yourCorrectCount/10)',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GlassCardSmall(
                              child: Column(
                                children: [
                                  const DataLabel('Avg Speed'),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${(avgSpeedMs / 1000).toStringAsFixed(1)}s',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    avgSpeedMs < 3000 ? 'Fast' : 'Slow',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 10,
                                      color: avgSpeedMs < 3000
                                          ? AppColors.signalGreen
                                          : AppColors.blazeOrange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Round breakdown
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: DataLabel('Round Breakdown'),
                      ),
                      const SizedBox(height: 8),
                      ...rounds.map((r) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: RoundResultCard(
                              roundNumber: r.round,
                              questionText: r.questionText,
                              correctAnswer: r.correctAnswer,
                              playerResult: r.yourCorrect
                                  ? '\u2713 ${(r.yourTimeMs / 1000).toStringAsFixed(1)}s'
                                  : '\u2717 ${(r.yourTimeMs / 1000).toStringAsFixed(1)}s',
                              opponentResult: r.theirCorrect
                                  ? '\u2713 ${(r.theirTimeMs / 1000).toStringAsFixed(1)}s'
                                  : '\u2717 ${(r.theirTimeMs / 1000).toStringAsFixed(1)}s',
                              playerCorrect: r.yourCorrect,
                              opponentCorrect: r.theirCorrect,
                            ),
                          )),
                    ],
                  ),
                ),
              ),

              // Action buttons
              const SizedBox(height: 12),
              ClayButton(
                label: '\u21BA Rematch',
                isFullWidth: true,
                onPressed: () => context.go('/category-select'),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => context.go('/home'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Back to The Hub',
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const HomeIndicator(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
