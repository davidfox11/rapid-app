import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/search_bar_widget.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('RapidSearchBar', () {
    testWidgets('renders hint text', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(_wrap(
        RapidSearchBar(
          hintText: 'Search friends...',
          controller: controller,
        ),
      ));
      expect(find.text('Search friends...'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('calls onChanged when typing', (tester) async {
      final controller = TextEditingController();
      String? lastValue;
      await tester.pumpWidget(_wrap(
        RapidSearchBar(
          hintText: 'Search',
          controller: controller,
          onChanged: (v) => lastValue = v,
        ),
      ));
      await tester.enterText(find.byType(TextField), 'hello');
      expect(lastValue, 'hello');
      controller.dispose();
    });

    testWidgets('shows search icon', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(_wrap(
        RapidSearchBar(hintText: 'Search', controller: controller),
      ));
      expect(find.byIcon(Icons.search), findsOneWidget);
      controller.dispose();
    });
  });
}
