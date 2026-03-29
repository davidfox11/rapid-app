import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/models/ws_messages.dart';

void main() {
  group('WsEnvelope', () {
    test('fromJson parses envelope', () {
      final json = {
        'type': 'question',
        'payload': {'round': 1, 'text': 'Test?'},
      };
      final env = WsEnvelope.fromJson(json);
      expect(env.type, 'question');
      expect(env.payload['round'], 1);
    });

    test('toJson round-trips', () {
      const env = WsEnvelope(
        type: 'answer',
        payload: {'round': 1, 'choice': 2},
      );
      final json = env.toJson();
      expect(json['type'], 'answer');
      expect((json['payload'] as Map)['choice'], 2);
    });
  });

  group('RoundResultMsg', () {
    test('fromJson parses all fields', () {
      final json = {
        'round': 3,
        'your_choice': 1,
        'your_correct': true,
        'your_points': 850,
        'their_choice': 2,
        'their_correct': false,
        'their_points': 0,
        'your_total': 2500,
        'their_total': 1800,
        'correct_index': 1,
        'your_time_ms': 1500,
        'their_time_ms': 3200,
      };
      final msg = RoundResultMsg.fromJson(json);
      expect(msg.round, 3);
      expect(msg.yourCorrect, isTrue);
      expect(msg.theirCorrect, isFalse);
      expect(msg.yourTotal, 2500);
      expect(msg.correctIndex, 1);
    });
  });

  group('GameEndMsg', () {
    test('fromJson parses result', () {
      final json = {
        'match_id': 'm_1',
        'result': 'win',
        'your_total': 6800,
        'their_total': 5200,
        'rating_change': 18,
      };
      final msg = GameEndMsg.fromJson(json);
      expect(msg.result, 'win');
      expect(msg.ratingChange, 18);
    });
  });

  group('Client messages', () {
    test('ChallengeMsg toJson', () {
      const msg = ChallengeMsg(opponentId: 'u_2', categoryId: 'cat_1');
      final json = msg.toJson();
      expect(json['type'], 'challenge');
      expect((json['payload'] as Map)['opponent_id'], 'u_2');
    });

    test('AnswerMsg toJson', () {
      const msg = AnswerMsg(round: 3, choice: 1);
      final json = msg.toJson();
      expect(json['type'], 'answer');
      expect((json['payload'] as Map)['choice'], 1);
    });

    test('PongMsg toJson', () {
      const msg = PongMsg(serverTs: 1234567890);
      final json = msg.toJson();
      expect(json['type'], 'pong');
      expect((json['payload'] as Map)['server_ts'], 1234567890);
    });
  });
}
