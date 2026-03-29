import 'package:flutter/foundation.dart';

@immutable
class Friend {
  const Friend({
    required this.id,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    required this.defaultAvatarIndex,
    required this.rating,
    required this.status,
    this.lastSeenAt,
    required this.h2hWins,
    required this.h2hLosses,
  });

  final String id;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final int defaultAvatarIndex;
  final int rating;
  final String status; // "online" | "offline" | "in_match"
  final DateTime? lastSeenAt;
  final int h2hWins;
  final int h2hLosses;

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        id: json['id'] as String,
        username: json['username'] as String,
        displayName: json['display_name'] as String,
        avatarUrl: json['avatar_url'] as String?,
        defaultAvatarIndex: json['default_avatar_index'] as int,
        rating: json['rating'] as int,
        status: json['status'] as String,
        lastSeenAt: json['last_seen_at'] != null
            ? DateTime.parse(json['last_seen_at'] as String)
            : null,
        h2hWins: json['h2h_wins'] as int,
        h2hLosses: json['h2h_losses'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'display_name': displayName,
        'avatar_url': avatarUrl,
        'default_avatar_index': defaultAvatarIndex,
        'rating': rating,
        'status': status,
        'last_seen_at': lastSeenAt?.toIso8601String(),
        'h2h_wins': h2hWins,
        'h2h_losses': h2hLosses,
      };
}
