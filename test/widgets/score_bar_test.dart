import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/score_bar.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ScoreBar', () {
    testWidgets('renders both scores and category', (tester) async {
      await tester.pumpWidget(_wrap(
        const ScoreBar(
          playerAvatar: SizedBox(width: 26, height: 26),
          playerScore: 2450,
          opponentAvatar: SizedBox(width: 26, height: 26),
          opponentScore: 1800,
          categoryLabel: 'History',
        ),
      ));
      expect(find.text('2450'), findsOneWidget);
      expect(find.text('1800'), findsOneWidget);
      expect(find.text('HISTORY'), findsOneWidget);
    });
  });
}
