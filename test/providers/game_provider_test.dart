import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/data/mock_data.dart';
import 'package:rapid_app/models/game_state.dart';
import 'package:rapid_app/providers/game_provider.dart';

void main() {
  group('GameNotifier', () {
    late GameNotifier notifier;

    setUp(() {
      notifier = GameNotifier();
    });

    tearDown(() {
      notifier.dispose();
    });

    test('starts as null', () {
      expect(notifier.state, isNull);
    });

    test('startGame creates initial state', () async {
      notifier.startGame(MockData.friends[0], MockData.categories[0]);
      expect(notifier.state, isNotNull);
      expect(notifier.state!.currentRound, 1);
      expect(notifier.state!.yourScore, 0);
      expect(notifier.state!.theirScore, 0);
      expect(notifier.state!.opponentName, 'Sarah');
    });

    test('startGame transitions to active after delay', () async {
      notifier.startGame(MockData.friends[0], MockData.categories[0]);
      expect(notifier.state!.phase, GamePhase.waiting);
      await Future.delayed(const Duration(milliseconds: 300));
      expect(notifier.state!.phase, GamePhase.active);
    });

    test('submitAnswer transitions to answered phase', () async {
      notifier.startGame(MockData.friends[0], MockData.categories[0]);
      await Future.delayed(const Duration(milliseconds: 300));
      notifier.submitAnswer(0);
      expect(notifier.state!.phase, GamePhase.answered);
      expect(notifier.state!.selectedOptionIndex, 0);
    });

    test('handleTimeout transitions to answered phase', () async {
      notifier.startGame(MockData.friends[0], MockData.categories[0]);
      await Future.delayed(const Duration(milliseconds: 300));
      notifier.handleTimeout();
      expect(notifier.state!.phase, GamePhase.answered);
      expect(notifier.state!.selectedOptionIndex, -1);
    });

    test('nextRound advances round counter', () async {
      notifier.startGame(MockData.friends[0], MockData.categories[0]);
      await Future.delayed(const Duration(milliseconds: 300));
      notifier.submitAnswer(0);
      // Simulate opponent answered + reveal
      await Future.delayed(const Duration(seconds: 3));
      if (notifier.state!.phase == GamePhase.revealing) {
        notifier.nextRound();
        await Future.delayed(const Duration(milliseconds: 300));
        expect(notifier.state!.currentRound, 2);
      }
    });
  });
}
