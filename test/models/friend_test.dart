import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/models/friend.dart';

void main() {
  group('Friend', () {
    final json = {
      'id': 'u_2',
      'username': 'sarah_oz',
      'display_name': 'Sarah',
      'avatar_url': null,
      'default_avatar_index': 6,
      'rating': 1520,
      'status': 'online',
      'last_seen_at': null,
      'h2h_wins': 12,
      'h2h_losses': 8,
    };

    test('fromJson creates correct instance', () {
      final friend = Friend.fromJson(json);
      expect(friend.username, 'sarah_oz');
      expect(friend.status, 'online');
      expect(friend.h2hWins, 12);
      expect(friend.lastSeenAt, isNull);
    });

    test('toJson round-trips correctly', () {
      final friend = Friend.fromJson(json);
      final output = friend.toJson();
      expect(output['status'], 'online');
      expect(output['h2h_wins'], 12);
      expect(output['h2h_losses'], 8);
    });

    test('handles lastSeenAt when present', () {
      final jsonWithTime = Map<String, dynamic>.from(json)
        ..['last_seen_at'] = '2026-03-29T10:00:00.000';
      final friend = Friend.fromJson(jsonWithTime);
      expect(friend.lastSeenAt, isNotNull);
    });
  });
}
