import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/models/question.dart';

void main() {
  group('Question', () {
    final json = {
      'round': 1,
      'text': 'What is the capital of France?',
      'options': ['Paris', 'London', 'Berlin', 'Madrid'],
      'timeout_ms': 15000,
    };

    test('fromJson creates correct instance', () {
      final q = Question.fromJson(json);
      expect(q.round, 1);
      expect(q.text, 'What is the capital of France?');
      expect(q.options, hasLength(4));
      expect(q.options[0], 'Paris');
      expect(q.timeoutMs, 15000);
    });

    test('toJson round-trips correctly', () {
      final q = Question.fromJson(json);
      final output = q.toJson();
      expect(output['round'], 1);
      expect(output['options'], hasLength(4));
      expect(output['timeout_ms'], 15000);
    });
  });
}
