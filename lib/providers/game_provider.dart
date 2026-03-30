import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../models/category.dart';
import '../models/friend.dart';
import '../models/game_state.dart';

final gameProvider =
    StateNotifierProvider<GameNotifier, ActiveGameState?>((ref) {
  return GameNotifier();
});

class GameNotifier extends StateNotifier<ActiveGameState?> {
  GameNotifier() : super(null);

  final _rng = Random();
  Timer? _opponentTimer;
  Timer? _phaseTimer;
  Timer? _revealedTimer;
  DateTime? _questionStartTime;

  void _cancelAllTimers() {
    _opponentTimer?.cancel();
    _phaseTimer?.cancel();
    _revealedTimer?.cancel();
  }

  void startGame(Friend opponent, Category category) {
    _cancelAllTimers();
    final question = MockData.mockQuestions[0];
    state = ActiveGameState(
      matchId: 'm_${DateTime.now().millisecondsSinceEpoch}',
      opponentName: opponent.displayName,
      opponentAvatarUrl: opponent.avatarUrl,
      opponentDefaultAvatarIndex: opponent.defaultAvatarIndex,
      categoryName: category.name,
      totalRounds: 10,
      currentRound: 1,
      yourScore: 0,
      theirScore: 0,
      phase: GamePhase.preview,
      currentQuestion: question,
      roundResults: const [],
    );
    // Preview delay based on question text length
    final previewMs = _previewDuration(question.text);
    _phaseTimer = Timer(Duration(milliseconds: previewMs), () {
      if (!mounted || state == null) return;
      _questionStartTime = DateTime.now();
      state = state!.copyWith(phase: GamePhase.active);
      _scheduleOpponentAnswer();
    });
  }

  /// Returns preview duration in ms: 2000 for short questions, 3000 for long.
  int _previewDuration(String text) {
    return text.length > 80 ? 3000 : 2000;
  }

  void _scheduleOpponentAnswer() {
    final delay = Duration(milliseconds: 1500 + _rng.nextInt(4500));
    _opponentTimer?.cancel();
    _opponentTimer = Timer(delay, () {
      if (state == null ||
          state!.phase == GamePhase.revealing ||
          state!.phase == GamePhase.revealed) {
        return;
      }
      state = state!.copyWith(opponentAnswered: true);
      // If we're already in answered phase, start suspense
      if (state!.phase == GamePhase.answered) {
        _startSuspensePause();
      }
    });
  }

  void submitAnswer(int optionIndex) {
    if (state == null || state!.phase != GamePhase.active) return;
    final elapsed = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inMilliseconds
        : 5000;
    state = state!.copyWith(
      phase: GamePhase.answered,
      selectedOptionIndex: optionIndex,
      yourTimeMs: elapsed,
    );
    if (state!.opponentAnswered) {
      _startSuspensePause();
    }
  }

  void handleTimeout() {
    if (state == null || state!.phase != GamePhase.active) return;
    state = state!.copyWith(
      phase: GamePhase.answered,
      selectedOptionIndex: -1, // timeout
      yourTimeMs: 15000,
    );
    if (state!.opponentAnswered) {
      _startSuspensePause();
    }
  }

  void _startSuspensePause() {
    _phaseTimer?.cancel();
    _phaseTimer = Timer(const Duration(milliseconds: 800), () {
      if (!mounted || state == null) return;
      _revealResult();
    });
  }

  void _revealResult() {
    if (!mounted || state == null) return;
    final s = state!;

    // Correct answer is always index 0 in mock data
    const correctIndex = 0;
    final yourChoice = s.selectedOptionIndex ?? -1;
    final yourCorrect = yourChoice == correctIndex;
    final yourTimeMs = s.yourTimeMs ?? 15000;

    // Opponent mock result
    final theirChoice = _rng.nextInt(4);
    final theirCorrect = theirChoice == correctIndex;
    final theirTimeMs = 1000 + _rng.nextInt(7000);

    // Points: faster = more, max 1000, min 100. 0 if wrong.
    int calcPoints(bool correct, int timeMs) {
      if (!correct) return 0;
      return max(100, 1000 - (timeMs ~/ 15));
    }

    final yourPoints = calcPoints(yourCorrect, yourTimeMs);
    final theirPoints = calcPoints(theirCorrect, theirTimeMs);

    // Determine round winner
    String roundWinner;
    if (yourPoints > theirPoints) {
      roundWinner = 'you';
    } else if (theirPoints > yourPoints) {
      roundWinner = 'them';
    } else {
      roundWinner = 'draw';
    }

    // Set to revealing (suspense phase)
    state = s.copyWith(
      phase: GamePhase.revealing,
      yourChoice: yourChoice,
      theirChoice: theirChoice,
      yourCorrect: yourCorrect,
      theirCorrect: theirCorrect,
      yourPoints: yourPoints,
      theirPoints: theirPoints,
      correctIndex: correctIndex,
      yourTimeMs: yourTimeMs,
      theirTimeMs: theirTimeMs,
      yourScore: s.yourScore + yourPoints,
      theirScore: s.theirScore + theirPoints,
      roundResults: [...s.roundResults, roundWinner],
    );

    // After 800ms suspense, transition to revealed (result display)
    _revealedTimer?.cancel();
    _revealedTimer = Timer(const Duration(milliseconds: 800), () {
      if (!mounted || state == null) return;
      state = state!.copyWith(phase: GamePhase.revealed);
    });
  }

  void nextRound() {
    if (!mounted || state == null) return;
    final s = state!;

    if (s.currentRound >= s.totalRounds) {
      endGame();
      return;
    }

    _cancelAllTimers();

    final nextRound = s.currentRound + 1;
    final nextQuestion = MockData.mockQuestions[nextRound - 1];

    state = ActiveGameState(
      matchId: s.matchId,
      opponentName: s.opponentName,
      opponentAvatarUrl: s.opponentAvatarUrl,
      opponentDefaultAvatarIndex: s.opponentDefaultAvatarIndex,
      categoryName: s.categoryName,
      totalRounds: s.totalRounds,
      currentRound: nextRound,
      yourScore: s.yourScore,
      theirScore: s.theirScore,
      phase: GamePhase.preview,
      currentQuestion: nextQuestion,
      roundResults: s.roundResults,
    );

    final previewMs = _previewDuration(nextQuestion.text);
    _phaseTimer = Timer(Duration(milliseconds: previewMs), () {
      if (!mounted || state == null) return;
      _questionStartTime = DateTime.now();
      state = state!.copyWith(phase: GamePhase.active);
      _scheduleOpponentAnswer();
    });
  }

  void endGame() {
    // State stays as-is -- the gameplay screen reads it and navigates
    _cancelAllTimers();
  }

  @override
  void dispose() {
    _cancelAllTimers();
    super.dispose();
  }
}
