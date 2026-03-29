import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/home_indicator.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('HomeIndicator', () {
    testWidgets('renders centered container', (tester) async {
      await tester.pumpWidget(_wrap(const HomeIndicator()));
      expect(find.byType(HomeIndicator), findsOneWidget);

      // Verify the inner Container dimensions
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(HomeIndicator),
          matching: find.byType(Container),
        ),
      );
      expect(container.constraints?.maxWidth, 134);
      expect(container.constraints?.maxHeight, 5);
    });
  });
}
