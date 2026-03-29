import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/models/user.dart';

void main() {
  group('User', () {
    final json = {
      'id': 'u_1',
      'username': 'testuser',
      'display_name': 'Test User',
      'avatar_url': 'https://example.com/photo.jpg',
      'default_avatar_index': 3,
      'rating': 1500,
      'created_at': '2025-06-15T00:00:00.000',
    };

    test('fromJson creates correct instance', () {
      final user = User.fromJson(json);
      expect(user.id, 'u_1');
      expect(user.username, 'testuser');
      expect(user.displayName, 'Test User');
      expect(user.avatarUrl, 'https://example.com/photo.jpg');
      expect(user.defaultAvatarIndex, 3);
      expect(user.rating, 1500);
    });

    test('toJson round-trips correctly', () {
      final user = User.fromJson(json);
      final output = user.toJson();
      expect(output['id'], json['id']);
      expect(output['username'], json['username']);
      expect(output['display_name'], json['display_name']);
      expect(output['default_avatar_index'], json['default_avatar_index']);
    });

    test('handles null avatarUrl', () {
      final jsonNoAvatar = Map<String, dynamic>.from(json)
        ..['avatar_url'] = null;
      final user = User.fromJson(jsonNoAvatar);
      expect(user.avatarUrl, isNull);
    });
  });
}
