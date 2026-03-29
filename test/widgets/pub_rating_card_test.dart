import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/pub_rating_card.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('PubRatingCard', () {
    testWidgets('renders rating and positive delta', (tester) async {
      await tester.pumpWidget(_wrap(
        const PubRatingCard(rating: 1247, weeklyDelta: 42),
      ));
      expect(find.text('1247'), findsOneWidget);
      expect(find.text('▲ 42 this week'), findsOneWidget);
    });

    testWidgets('renders negative delta with down arrow', (tester) async {
      await tester.pumpWidget(_wrap(
        const PubRatingCard(rating: 980, weeklyDelta: -15),
      ));
      expect(find.text('980'), findsOneWidget);
      expect(find.text('▼ 15 this week'), findsOneWidget);
    });
  });
}
