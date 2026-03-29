import 'package:flutter/foundation.dart';

@immutable
class MatchRound {
  const MatchRound({
    required this.round,
    required this.questionText,
    required this.correctAnswer,
    required this.yourChoice,
    required this.yourCorrect,
    required this.yourTimeMs,
    required this.theirChoice,
    required this.theirCorrect,
    required this.theirTimeMs,
    required this.yourPoints,
    required this.theirPoints,
  });

  final int round;
  final String questionText;
  final String correctAnswer;
  final int yourChoice;
  final bool yourCorrect;
  final int yourTimeMs;
  final int theirChoice;
  final bool theirCorrect;
  final int theirTimeMs;
  final int yourPoints;
  final int theirPoints;

  factory MatchRound.fromJson(Map<String, dynamic> json) => MatchRound(
        round: json['round'] as int,
        questionText: json['question_text'] as String,
        correctAnswer: json['correct_answer'] as String,
        yourChoice: json['your_choice'] as int,
        yourCorrect: json['your_correct'] as bool,
        yourTimeMs: json['your_time_ms'] as int,
        theirChoice: json['their_choice'] as int,
        theirCorrect: json['their_correct'] as bool,
        theirTimeMs: json['their_time_ms'] as int,
        yourPoints: json['your_points'] as int,
        theirPoints: json['their_points'] as int,
      );

  Map<String, dynamic> toJson() => {
        'round': round,
        'question_text': questionText,
        'correct_answer': correctAnswer,
        'your_choice': yourChoice,
        'your_correct': yourCorrect,
        'your_time_ms': yourTimeMs,
        'their_choice': theirChoice,
        'their_correct': theirCorrect,
        'their_time_ms': theirTimeMs,
        'your_points': yourPoints,
        'their_points': theirPoints,
      };
}
