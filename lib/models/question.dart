import 'package:flutter/foundation.dart';

@immutable
class Question {
  const Question({
    required this.round,
    required this.text,
    required this.options,
    required this.timeoutMs,
  });

  final int round;
  final String text;
  final List<String> options;
  final int timeoutMs;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        round: json['round'] as int,
        text: json['text'] as String,
        options: (json['options'] as List).cast<String>(),
        timeoutMs: json['timeout_ms'] as int,
      );

  Map<String, dynamic> toJson() => {
        'round': round,
        'text': text,
        'options': options,
        'timeout_ms': timeoutMs,
      };
}
