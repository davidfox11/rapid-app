import 'package:flutter/foundation.dart';

@immutable
class Match {
  const Match({
    required this.id,
    required this.opponentName,
    this.opponentAvatarUrl,
    required this.opponentDefaultAvatarIndex,
    required this.categoryName,
    required this.yourScore,
    required this.theirScore,
    required this.result,
    required this.ratingChange,
    required this.playedAt,
  });

  final String id;
  final String opponentName;
  final String? opponentAvatarUrl;
  final int opponentDefaultAvatarIndex;
  final String categoryName;
  final int yourScore;
  final int theirScore;
  final String result; // "win" | "loss" | "draw"
  final int ratingChange;
  final DateTime playedAt;

  factory Match.fromJson(Map<String, dynamic> json) => Match(
        id: json['id'] as String,
        opponentName: json['opponent_name'] as String,
        opponentAvatarUrl: json['opponent_avatar_url'] as String?,
        opponentDefaultAvatarIndex:
            json['opponent_default_avatar_index'] as int,
        categoryName: json['category_name'] as String,
        yourScore: json['your_score'] as int,
        theirScore: json['their_score'] as int,
        result: json['result'] as String,
        ratingChange: json['rating_change'] as int,
        playedAt: DateTime.parse(json['played_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'opponent_name': opponentName,
        'opponent_avatar_url': opponentAvatarUrl,
        'opponent_default_avatar_index': opponentDefaultAvatarIndex,
        'category_name': categoryName,
        'your_score': yourScore,
        'their_score': theirScore,
        'result': result,
        'rating_change': ratingChange,
        'played_at': playedAt.toIso8601String(),
      };
}
