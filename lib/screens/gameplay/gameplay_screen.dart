import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../models/game_state.dart';
import '../../providers/auth_provider.dart';
import '../../providers/game_provider.dart';
import '../../providers/game_setup_provider.dart';
import '../../widgets/compact_score_bar.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/data_label.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/home_indicator.dart';
import '../../widgets/icon_circle.dart';
import '../../widgets/option_button.dart';
import '../../widgets/rapid_avatar.dart';
import '../../widgets/round_dots.dart';
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
        // Haptic at 3, 2, 1 seconds only
        if (_remainingSeconds <= 3 &&
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

  Future<void> _confirmExit() async {
    _stopTimer();
    final confirmed = await showConfirmDialog(
      context,
      title: 'Quit Match?',
      message: 'You\'ll forfeit this game and it will count as a loss.',
      confirmLabel: 'Leave',
      cancelLabel: 'Stay',
    );
    if (confirmed && mounted) {
      ref.read(gameProvider.notifier).endGame();
      context.go('/home');
    } else if (mounted) {
      // Resume timer if they chose to stay and game is still active
      final game = ref.read(gameProvider);
      if (game?.phase == GamePhase.active) {
        _startTimer();
      }
    }
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
      if (game.phase == GamePhase.revealed && prev != GamePhase.revealed) {
        _stopTimer();
        if (game.yourCorrect == true) {
          HapticFeedback.lightImpact();
          Future.delayed(const Duration(milliseconds: 80), () =>
              HapticFeedback.lightImpact());
          Future.delayed(const Duration(milliseconds: 160), () =>
              HapticFeedback.lightImpact());
        } else {
          HapticFeedback.heavyImpact();
        }
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _startRevealCountdown());
      }
    }

    if (game.phase == GamePhase.revealed) {
      return _buildRevealedPhase(game, user);
    }
    if (game.phase == GamePhase.revealing) {
      // Brief suspense — show the active/answered state still
      return _buildActivePhase(game, user);
    }
    if (game.phase == GamePhase.preview) {
      return _buildPreviewPhase(game, user);
    }
    return _buildActivePhase(game, user);
  }

  // ─── PREVIEW PHASE ─────────────────────────────────────────────

  Widget _buildPreviewPhase(ActiveGameState game, dynamic user) {
    final q = game.currentQuestion;
    final questionText = q?.text ?? '';
    final fontSize = questionText.length > 120 ? 22.0 : 26.0;

    return ScreenBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Exit button + CompactScoreBar
              Row(
                children: [
                  IconCircle(
                    size: 30,
                    onTap: _confirmExit,
                    child: const Icon(Icons.close,
                        color: AppColors.textSecondary, size: 14),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CompactScoreBar(
                      playerAvatar: RapidAvatar(
                        avatarUrl: user.avatarUrl,
                        defaultAvatarIndex: user.defaultAvatarIndex,
                        size: 28,
                      ),
                      playerScore: game.yourScore,
                      opponentAvatar: RapidAvatar(
                        avatarUrl: game.opponentAvatarUrl,
                        defaultAvatarIndex: game.opponentDefaultAvatarIndex,
                        size: 28,
                      ),
                      opponentScore: game.theirScore,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Round dots
              RoundDots(
                currentRound: game.currentRound,
                totalRounds: game.totalRounds,
                roundResults: game.roundResults,
              ),
              const SizedBox(height: 20),

              // Category label + round label
              Text(
                game.categoryName.toUpperCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppColors.amberGlow,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              DataLabel('Round ${game.currentRound} of ${game.totalRounds}'),
              const SizedBox(height: 24),

              // Large centered question card
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 28),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 191, 94, 0.03),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color.fromRGBO(255, 191, 94, 0.15),
                      ),
                    ),
                    child: Text(
                      questionText,
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        height: 1.45,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
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

  // ─── ACTIVE PHASE ──────────────────────────────────────────────

  Widget _buildActivePhase(ActiveGameState game, dynamic user) {
    final q = game.currentQuestion;
    final isAnswered = game.phase == GamePhase.answered ||
        game.phase == GamePhase.revealing;
    final questionText = q?.text ?? '';
    final questionFontSize = questionText.length > 120 ? 15.0 : 17.0;

    return ScreenBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Exit button + CompactScoreBar
              Row(
                children: [
                  IconCircle(
                    size: 30,
                    onTap: _confirmExit,
                    child: const Icon(Icons.close,
                        color: AppColors.textSecondary, size: 14),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CompactScoreBar(
                      playerAvatar: RapidAvatar(
                        avatarUrl: user.avatarUrl,
                        defaultAvatarIndex: user.defaultAvatarIndex,
                        size: 28,
                      ),
                      playerScore: game.yourScore,
                      opponentAvatar: RapidAvatar(
                        avatarUrl: game.opponentAvatarUrl,
                        defaultAvatarIndex: game.opponentDefaultAvatarIndex,
                        size: 28,
                      ),
                      opponentScore: game.theirScore,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Round dots
              RoundDots(
                currentRound: game.currentRound,
                totalRounds: game.totalRounds,
                roundResults: game.roundResults,
              ),
              const SizedBox(height: 16),

              // Timer
              TimerRing(
                totalSeconds: 15,
                remainingSeconds: _remainingSeconds,
                size: 64,
              ),
              const SizedBox(height: 8),

              // Opponent status (right-aligned)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RapidAvatar(
                    avatarUrl: game.opponentAvatarUrl,
                    defaultAvatarIndex: game.opponentDefaultAvatarIndex,
                    size: 16,
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
              const SizedBox(height: 8),

              // Shrunk question card
              if (q != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 22, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color.fromRGBO(255, 255, 255, 0.06),
                    ),
                  ),
                  child: Text(
                    questionText,
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: questionFontSize,
                      fontWeight: FontWeight.w700,
                      height: 1.45,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 8),

              // Options with staggered entrance
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
                        )
                            .animate()
                            .fadeIn(
                              duration: 200.ms,
                              delay: (80 * i).ms,
                            )
                            .moveY(
                              begin: 20,
                              end: 0,
                              duration: 200.ms,
                              delay: (80 * i).ms,
                              curve: Curves.easeOut,
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

  // ─── REVEALED PHASE ────────────────────────────────────────────

  Widget _buildRevealedPhase(ActiveGameState game, dynamic user) {
    final q = game.currentQuestion;
    final correctIdx = game.correctIndex ?? 0;

    // Outcome text
    final bothCorrect =
        game.yourCorrect == true && game.theirCorrect == true;
    final bothWrong =
        game.yourCorrect != true && game.theirCorrect != true;
    final youCorrect = game.yourCorrect == true;
    final theyCorrect = game.theirCorrect == true;

    String outcomeText;
    Color outcomeColor;
    if (bothCorrect) {
      outcomeText = 'Both correct!';
      outcomeColor = AppColors.signalGreen;
    } else if (bothWrong) {
      outcomeText = 'Both wrong!';
      outcomeColor = AppColors.blazeOrange;
    } else if (youCorrect) {
      outcomeText = 'You got it!';
      outcomeColor = AppColors.signalGreen;
    } else {
      outcomeText = 'They got it';
      outcomeColor = AppColors.blazeOrange;
    }

    return ScreenBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Category + round label centered
              Text(
                game.categoryName.toUpperCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              DataLabel('Round ${game.currentRound} of ${game.totalRounds}'),
              const SizedBox(height: 12),

              // Reveal header
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
                              color: youCorrect
                                  ? AppColors.signalGreen
                                  : AppColors.blazeOrange,
                              width: 2,
                            ),
                          ),
                          child: RapidAvatar(
                            avatarUrl: user.avatarUrl,
                            defaultAvatarIndex: user.defaultAvatarIndex,
                            size: 44,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'You',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        _PointBurstPill(
                          points: game.yourPoints ?? 0,
                          isFaster: (game.yourTimeMs ?? 99999) <
                              (game.theirTimeMs ?? 0),
                          isCorrect: youCorrect,
                        ),
                      ],
                    ),
                  ),

                  // Center scores + outcome
                  Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            game.yourScore.toString(),
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: game.yourScore >= game.theirScore
                                  ? AppColors.signalGreen
                                  : AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            ' - ',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          Text(
                            game.theirScore.toString(),
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: game.theirScore >= game.yourScore
                                  ? AppColors.signalGreen
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        outcomeText,
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 13,
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
                              color: theyCorrect
                                  ? AppColors.signalGreen
                                  : AppColors.blazeOrange,
                              width: 2,
                            ),
                          ),
                          child: RapidAvatar(
                            avatarUrl: game.opponentAvatarUrl,
                            defaultAvatarIndex: game.opponentDefaultAvatarIndex,
                            size: 44,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          game.opponentName,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        _PointBurstPill(
                          points: game.theirPoints ?? 0,
                          isFaster: (game.theirTimeMs ?? 99999) <
                              (game.yourTimeMs ?? 0),
                          isCorrect: theyCorrect,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Mini tug bar
              _MiniTugBar(
                yourScore: game.yourScore,
                theirScore: game.theirScore,
              ),
              const SizedBox(height: 12),

              // Question card + correct answer
              if (q != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color.fromRGBO(255, 255, 255, 0.10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        q.text,
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
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

              // Options with reveal state + pick tags
              if (q != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...List.generate(q.options.length, (i) {
                          final letters = ['A', 'B', 'C', 'D'];
                          OptionState optState;
                          final isCorrectOption = i == correctIdx;
                          final youPicked = i == game.yourChoice;
                          final theyPicked = i == game.theirChoice;

                          if (isCorrectOption) {
                            optState = OptionState.correct;
                          } else if (youPicked || theyPicked) {
                            optState = OptionState.wrong;
                          } else {
                            optState = OptionState.dimmed;
                          }

                          // Build pick tags
                          Widget? trailing;
                          if (youPicked || theyPicked) {
                            final tags = <Widget>[];
                            if (youPicked && game.yourChoice != -1) {
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
                                      padding:
                                          const EdgeInsets.only(left: 4),
                                      child: t,
                                    )),
                                const SizedBox(width: 6),
                                Icon(
                                  isCorrectOption
                                      ? Icons.check
                                      : Icons.close,
                                  size: 16,
                                  color: isCorrectOption
                                      ? AppColors.signalGreen
                                      : AppColors.blazeOrange,
                                ),
                              ],
                            );
                          } else if (isCorrectOption && bothWrong) {
                            // Both wrong: show correct answer at 0.7 opacity
                            // with CORRECT label
                            trailing = Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.signalGreen
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: AppColors.signalGreen
                                          .withValues(alpha: 0.3),
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
                                  size: 16,
                                  color: AppColors.signalGreen,
                                ),
                              ],
                            );
                          }

                          // Adjust opacity for unchosen wrong options
                          final opacity = optState == OptionState.dimmed
                              ? 0.25
                              : (isCorrectOption && bothWrong ? 0.7 : 1.0);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Opacity(
                              opacity: opacity,
                              child: OptionButton(
                                letter: letters[i],
                                text: q.options[i],
                                state: optState,
                                playerAvatar: trailing,
                              ),
                            ),
                          );
                        }),

                        // Speed comparison card
                        const SizedBox(height: 8),
                        GlassCardSmall(
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
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
                                        color:
                                            (game.yourTimeMs ?? 99999) <
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
                                        color:
                                            (game.theirTimeMs ?? 99999) <
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
                          padding:
                              const EdgeInsets.only(top: 12, bottom: 8),
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

// ─── Point Burst Pill ──────────────────────────────────────────

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
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

// ─── Pick Tag ──────────────────────────────────────────────────

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

// ─── Mini Tug Bar (used in revealed phase) ─────────────────────

class _MiniTugBar extends StatelessWidget {
  const _MiniTugBar({
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
      height: 4,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 0.06),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Row(
            children: [
              Flexible(
                flex: (yourFraction * 1000).round().clamp(1, 999),
                child: Container(
                  color: AppColors.amberGlow.withValues(alpha: 0.6),
                ),
              ),
              Flexible(
                flex: ((1 - yourFraction) * 1000).round().clamp(1, 999),
                child: Container(
                  color: AppColors.signalGreen.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
