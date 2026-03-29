import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/category_card.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('CategoryCard', () {
    testWidgets('renders name and description', (tester) async {
      await tester.pumpWidget(_wrap(
        const CategoryCard(
          iconPath: 'assets/icons/categories/general_knowledge.svg',
          name: 'General Knowledge',
          description: 'A bit of everything',
          questionCount: 500,
        ),
      ));
      expect(find.text('General Knowledge'), findsOneWidget);
      expect(find.text('A bit of everything'), findsOneWidget);
      expect(find.text('500 Qs'), findsOneWidget);
    });

    testWidgets('renders SVG icon', (tester) async {
      await tester.pumpWidget(_wrap(
        const CategoryCard(
          iconPath: 'assets/icons/categories/movies.svg',
          name: 'Movies',
          description: 'Film',
          questionCount: 100,
        ),
      ));
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('responds to onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        CategoryCard(
          iconPath: 'assets/icons/categories/history.svg',
          name: 'History',
          description: 'Past events',
          questionCount: 200,
          onTap: () => tapped = true,
        ),
      ));
      await tester.tap(find.text('History'));
      expect(tapped, isTrue);
    });
  });
}
