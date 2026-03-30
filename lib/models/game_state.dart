import 'package:flutter/foundation.dart';

import 'question.dart';

enum GamePhase { preview, active, answered, revealing, revealed, transitioning }

@immutable
class ActiveGameState {
  const ActiveGameState({
    required this.matchId,
    required this.opponentName,
    this.opponentAvatarUrl,
    required this.opponentDefaultAvatarIndex,
    required this.categoryName,
    required this.totalRounds,
    required this.currentRound,
    required this.yourScore,
    required this.theirScore,
    required this.phase,
    this.currentQuestion,
    this.selectedOptionIndex,
    this.opponentAnswered = false,
    this.yourChoice,
    this.theirChoice,
    this.yourCorrect,
    this.theirCorrect,
    this.yourPoints,
    this.theirPoints,
    this.correctIndex,
    this.yourTimeMs,
    this.theirTimeMs,
    this.roundResults = const [],
  });

  final String matchId;
  final String opponentName;
  final String? opponentAvatarUrl;
  final int opponentDefaultAvatarIndex;
  final String categoryName;
  final int totalRounds;
  final int currentRound;
  final int yourScore;
  final int theirScore;
  final GamePhase phase;
  final Question? currentQuestion;
  final int? selectedOptionIndex;
  final bool opponentAnswered;
  // Round result fields (populated during revealing phase)
  final int? yourChoice;
  final int? theirChoice;
  final bool? yourCorrect;
  final bool? theirCorrect;
  final int? yourPoints;
  final int? theirPoints;
  final int? correctIndex;
  final int? yourTimeMs;
  final int? theirTimeMs;
  final List<String> roundResults;

  ActiveGameState copyWith({
    String? matchId,
    String? opponentName,
    String? opponentAvatarUrl,
    int? opponentDefaultAvatarIndex,
    String? categoryName,
    int? totalRounds,
    int? currentRound,
    int? yourScore,
    int? theirScore,
    GamePhase? phase,
    Question? currentQuestion,
    int? selectedOptionIndex,
    bool? opponentAnswered,
    int? yourChoice,
    int? theirChoice,
    bool? yourCorrect,
    bool? theirCorrect,
    int? yourPoints,
    int? theirPoints,
    int? correctIndex,
    int? yourTimeMs,
    int? theirTimeMs,
    List<String>? roundResults,
  }) =>
      ActiveGameState(
        matchId: matchId ?? this.matchId,
        opponentName: opponentName ?? this.opponentName,
        opponentAvatarUrl: opponentAvatarUrl ?? this.opponentAvatarUrl,
        opponentDefaultAvatarIndex:
            opponentDefaultAvatarIndex ?? this.opponentDefaultAvatarIndex,
        categoryName: categoryName ?? this.categoryName,
        totalRounds: totalRounds ?? this.totalRounds,
        currentRound: currentRound ?? this.currentRound,
        yourScore: yourScore ?? this.yourScore,
        theirScore: theirScore ?? this.theirScore,
        phase: phase ?? this.phase,
        currentQuestion: currentQuestion ?? this.currentQuestion,
        selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
        opponentAnswered: opponentAnswered ?? this.opponentAnswered,
        yourChoice: yourChoice ?? this.yourChoice,
        theirChoice: theirChoice ?? this.theirChoice,
        yourCorrect: yourCorrect ?? this.yourCorrect,
        theirCorrect: theirCorrect ?? this.theirCorrect,
        yourPoints: yourPoints ?? this.yourPoints,
        theirPoints: theirPoints ?? this.theirPoints,
        correctIndex: correctIndex ?? this.correctIndex,
        yourTimeMs: yourTimeMs ?? this.yourTimeMs,
        theirTimeMs: theirTimeMs ?? this.theirTimeMs,
        roundResults: roundResults ?? this.roundResults,
      );
}
