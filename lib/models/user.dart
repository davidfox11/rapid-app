import 'package:flutter/foundation.dart';

@immutable
class User {
  const User({
    required this.id,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    required this.defaultAvatarIndex,
    required this.rating,
    required this.createdAt,
  });

  final String id;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final int defaultAvatarIndex;
  final int rating;
  final DateTime createdAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        username: json['username'] as String,
        displayName: json['display_name'] as String,
        avatarUrl: json['avatar_url'] as String?,
        defaultAvatarIndex: json['default_avatar_index'] as int,
        rating: json['rating'] as int,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'display_name': displayName,
        'avatar_url': avatarUrl,
        'default_avatar_index': defaultAvatarIndex,
        'rating': rating,
        'created_at': createdAt.toIso8601String(),
      };
}
