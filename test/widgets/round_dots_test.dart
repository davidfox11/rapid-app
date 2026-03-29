import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/round_dots.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('RoundDots', () {
    testWidgets('renders correct number of dots', (tester) async {
      await tester.pumpWidget(_wrap(
        const RoundDots(currentRound: 3, totalRounds: 10),
      ));
      // RoundDots widget should be present
      expect(find.byType(RoundDots), findsOneWidget);
      // Find the Row inside RoundDots
      final row = tester.widget<Row>(find.descendant(
        of: find.byType(RoundDots),
        matching: find.byType(Row),
      ));
      // Row should have 10 children (each a Padding > Container)
      expect(row.children.length, 10);
    });

    testWidgets('renders with different total rounds', (tester) async {
      await tester.pumpWidget(_wrap(
        const RoundDots(currentRound: 1, totalRounds: 5),
      ));
      final row = tester.widget<Row>(find.descendant(
        of: find.byType(RoundDots),
        matching: find.byType(Row),
      ));
      expect(row.children.length, 5);
    });
  });
}
