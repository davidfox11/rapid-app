import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/round_result_card.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('RoundResultCard', () {
    testWidgets('renders round number and question', (tester) async {
      await tester.pumpWidget(_wrap(
        const RoundResultCard(
          roundNumber: 3,
          questionText: 'What is the capital of France?',
          correctAnswer: 'Paris',
          playerResult: '✓ 1.2s',
          opponentResult: '✕ 3.4s',
          playerCorrect: true,
          opponentCorrect: false,
        ),
      ));
      expect(find.text('Q3'), findsOneWidget);
      expect(find.text('What is the capital of France?'), findsOneWidget);
      expect(find.text('Paris'), findsOneWidget);
      expect(find.text('✓ 1.2s'), findsOneWidget);
      expect(find.text('✕ 3.4s'), findsOneWidget);
    });
  });
}
