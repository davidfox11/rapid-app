import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/icon_circle.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('IconCircle', () {
    testWidgets('renders child icon', (tester) async {
      await tester.pumpWidget(_wrap(
        const IconCircle(child: Icon(Icons.settings)),
      ));
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('responds to onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        IconCircle(
          onTap: () => tapped = true,
          child: const Icon(Icons.add),
        ),
      ));
      await tester.tap(find.byType(IconCircle));
      expect(tapped, isTrue);
    });

    testWidgets('uses custom size', (tester) async {
      await tester.pumpWidget(_wrap(
        const IconCircle(
          size: 60,
          child: Icon(Icons.person),
        ),
      ));
      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      expect(container.constraints?.maxWidth, 60);
    });

    testWidgets('no GestureDetector when onTap is null', (tester) async {
      await tester.pumpWidget(_wrap(
        const IconCircle(child: Icon(Icons.star)),
      ));
      expect(find.byType(GestureDetector), findsNothing);
    });
  });
}
