import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../models/game_state.dart';
import '../../providers/auth_provider.dart';
import '../../providers/game_provider.dart';
import '../../providers/game_setup_provider.dart';
import '../../widgets/data_label.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/home_indicator.dart';
import '../../widgets/option_button.dart';
import '../../widgets/rapid_avatar.dart';
import '../../widgets/round_dots.dart';
import '../../widgets/score_bar.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/timer_ring.dart';

class GameplayScreen extends ConsumerStatefulWidget {
  const GameplayScreen({super.key});

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen> {
  Timer? _timerTick;
  double _remainingSeconds = 15.0;
  Timer? _revealAdvance;
  int _revealCountdown = 4;
  bool _gameStarted = false;

  @override
  void initState() {
    super.initState();
    // Start the game on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_gameStarted) {
        _gameStarted = true;
        final opponent = ref.read(selectedOpponentProvider);
        final category = ref.read(selectedCategoryProvider);
        if (opponent != null && category != null) {
          ref.read(gameProvider.notifier).startGame(opponent, category);
        }
      }
    });
  }

  @override
  void dispose() {
    _timerTick?.cancel();
    _revealAdvance?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timerTick?.cancel();
    _remainingSeconds = 15.0;
    _timerTick = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _remainingSeconds -= 0.1;
        if (_remainingSeconds <= 0) {
          _remainingSeconds = 0;
          timer.cancel();
          ref.read(gameProvider.notifier).handleTimeout();
        }
        // Haptic on last 5 full seconds
        if (_remainingSeconds <= 5 &&
            _remainingSeconds > 0 &&
            (_remainingSeconds * 10).round() % 10 == 0) {
          HapticFeedback.selectionClick();
        }
      });
    });
  }

  void _stopTimer() {
    _timerTick?.cancel();
  }

  void _onOptionTap(int index) {
    HapticFeedback.mediumImpact();
    _stopTimer();
    ref.read(gameProvider.notifier).submitAnswer(index);
  }

  void _startRevealCountdown() {
    _revealAdvance?.cancel();
    _revealCountdown = 4;
    _revealAdvance = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _revealCountdown--;
        if (_revealCountdown <= 0) {
          timer.cancel();
          final game = ref.read(gameProvider);
          if (game != null && game.currentRound >= game.totalRounds) {
            context.go('/game-summary');
          } else {
            ref.read(gameProvider.notifier).nextRound();
          }
        }
      });
    });
  }

  GamePhase? _lastPhase;

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameProvider);
    final user = ref.watch(currentUserProvider);

    if (game == null) {
      return ScreenBackground(
        child: Center(
          child: Text('Loading...', style: AppTypography.serifH(fontSize: 24)),
        ),
      );
    }

    // React to phase transitions
    if (game.phase != _lastPhase) {
      final prev = _lastPhase;
      _lastPhase = game.phase;
      if (game.phase == GamePhase.active && prev != GamePhase.active) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _startTimer());
      }
      if (game.phase == GamePhase.revealing && prev != GamePhase.revealing) {
        _stopTimer();
        if (game.yourCorrect == true) {
          HapticFeedback.heavyImpact();
        } else {
          HapticFeedback.lightImpact();
        }
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _startRevealCountdown());
      }
    }

    if (game.phase == GamePhase.revealing) {
      return _buildRevealPhase(game, user);
    }
    return _buildActivePhase(game, user);
  }

  Widget _buildActivePhase(ActiveGameState game, dynamic user) {
    final q = game.currentQuestion;
    final isAnswered = game.phase == GamePhase.answered;

    return ScreenBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Score bar
              ScoreBar(
                playerAvatar: RapidAvatar(
                  avatarUrl: user.avatarUrl,
                  defaultAvatarIndex: user.defaultAvatarIndex,
                  size: 26,
                ),
                playerScore: game.yourScore,
                opponentAvatar: RapidAvatar(
                  avatarUrl: game.opponentAvatarUrl,
                  defaultAvatarIndex: game.opponentDefaultAvatarIndex,
                  size: 26,
                ),
                opponentScore: game.theirScore,
                categoryLabel: game.categoryName,
              ),
              const SizedBox(height: 16),

              // Round indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DataLabel('Round ${game.currentRound} of ${game.totalRounds}'),
                  RoundDots(
                    currentRound: game.currentRound,
                    totalRounds: game.totalRounds,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Timer
              TimerRing(
                totalSeconds: 15,
                remainingSeconds: _remainingSeconds,
              ),
              const SizedBox(height: 16),

              // Question card
              if (q != null)
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 4),
                    child: Center(
                      child: Text(
                        q.text,
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1.45,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),

              // Opponent status
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RapidAvatar(
                    avatarUrl: game.opponentAvatarUrl,
                    defaultAvatarIndex: game.opponentDefaultAvatarIndex,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    game.opponentAnswered ? 'answered!' : 'thinking...',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: game.opponentAnswered
                          ? AppColors.amberGlow
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Options
              if (q != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(q.options.length, (i) {
                        final letters = ['A', 'B', 'C', 'D'];
                        OptionState optState;
                        if (isAnswered && game.selectedOptionIndex == i) {
                          optState = OptionState.selected;
                        } else if (isAnswered) {
                          optState = OptionState.dimmed;
                        } else {
                          optState = OptionState.default_;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: OptionButton(
                            letter: letters[i],
                            text: q.options[i],
                            state: optState,
                            onTap: !isAnswered &&
                                    game.phase == GamePhase.active
                                ? () => _onOptionTap(i)
                                : null,
                          ),
                        );
                      }),
                    ),
                  ),
                ),

              if (isAnswered && !game.opponentAnswered)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Waiting for opponent...',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: AppColors.textTertiary,
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

  Widget _buildRevealPhase(ActiveGameState game, dynamic user) {
    final q = game.currentQuestion;
    final correctIdx = game.correctIndex ?? 0;

    return ScreenBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Header
              DataLabel(game.categoryName),
              const SizedBox(height: 6),
              Text('Answered!', style: AppTypography.serifH(fontSize: 22)),
              const SizedBox(height: 16),

              // Score delta row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // You
                  Column(
                    children: [
                      RapidAvatar(
                        avatarUrl: user.avatarUrl,
                        defaultAvatarIndex: user.defaultAvatarIndex,
                        size: 36,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'You ',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '(${game.yourScore})',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: game.yourCorrect == true
                                  ? AppColors.signalGreen
                                  : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '+${game.yourPoints ?? 0}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: game.yourCorrect == true
                              ? AppColors.signalGreen
                              : AppColors.blazeOrange,
                        ),
                      ),
                    ],
                  ),
                  DataLabel(
                    game.yourCorrect == true ? 'Correct' : 'Wrong',
                  ),
                  // Opponent
                  Column(
                    children: [
                      RapidAvatar(
                        avatarUrl: game.opponentAvatarUrl,
                        defaultAvatarIndex: game.opponentDefaultAvatarIndex,
                        size: 36,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${game.opponentName} ',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '(${game.theirScore})',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: game.theirCorrect == true
                                  ? AppColors.signalGreen
                                  : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '+${game.theirPoints ?? 0}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: game.theirCorrect == true
                              ? AppColors.signalGreen
                              : AppColors.blazeOrange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Question card with correct answer
              if (q != null)
                GlassCard(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 2),
                        child: Text(
                          q.text,
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Correct Answer: ',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              color: AppColors.amberGlow,
                            ),
                          ),
                          Text(
                            q.options[correctIdx],
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),

              // Options with results
              if (q != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...List.generate(q.options.length, (i) {
                          final letters = ['A', 'B', 'C', 'D'];
                          OptionState optState;
                          Widget? playerAv;
                          Widget? opponentAv;

                          if (i == correctIdx) {
                            optState = OptionState.correct;
                          } else if (i == game.yourChoice ||
                              i == game.theirChoice) {
                            optState = OptionState.wrong;
                          } else {
                            optState = OptionState.dimmed;
                          }

                          if (i == game.yourChoice) {
                            playerAv = Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RapidAvatar(
                                  avatarUrl: user.avatarUrl,
                                  defaultAvatarIndex:
                                      user.defaultAvatarIndex,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  game.yourCorrect == true ? '\u2713' : '\u2717',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: game.yourCorrect == true
                                        ? AppColors.signalGreen
                                        : AppColors.blazeOrange,
                                  ),
                                ),
                              ],
                            );
                          }
                          if (i == game.theirChoice) {
                            opponentAv = Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RapidAvatar(
                                  avatarUrl: game.opponentAvatarUrl,
                                  defaultAvatarIndex:
                                      game.opponentDefaultAvatarIndex,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  game.theirCorrect == true
                                      ? '\u2713'
                                      : '\u2717',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: game.theirCorrect == true
                                        ? AppColors.signalGreen
                                        : AppColors.blazeOrange,
                                  ),
                                ),
                              ],
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: OptionButton(
                              letter: letters[i],
                              text: q.options[i],
                              state: optState,
                              playerAvatar: playerAv,
                              opponentAvatar: opponentAv,
                            ),
                          );
                        }),

                        // Speed comparison
                        const SizedBox(height: 8),
                        GlassCardSmall(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: 'Your time: ',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '${((game.yourTimeMs ?? 0) / 1000).toStringAsFixed(1)}s'
                                          '${(game.yourTimeMs ?? 99999) < (game.theirTimeMs ?? 0) ? ' \u26A1' : ''}',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: (game.yourTimeMs ?? 99999) <
                                                (game.theirTimeMs ?? 0)
                                            ? AppColors.signalGreen
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Their time: ',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '${((game.theirTimeMs ?? 0) / 1000).toStringAsFixed(1)}s'
                                          '${(game.theirTimeMs ?? 99999) < (game.yourTimeMs ?? 0) ? ' \u26A1' : ''}',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: (game.theirTimeMs ?? 99999) <
                                                (game.yourTimeMs ?? 0)
                                            ? AppColors.signalGreen
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Auto-advance countdown
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 8),
                          child: Text(
                            game.currentRound >= game.totalRounds
                                ? 'Results in ${_revealCountdown}s...'
                                : 'Next round in ${_revealCountdown}s...',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      ],
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
