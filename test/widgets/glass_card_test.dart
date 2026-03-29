import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/glass_card.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('GlassCard', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(_wrap(
        const GlassCard(child: Text('Hello')),
      ));
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('applies backdrop filter', (tester) async {
      await tester.pumpWidget(_wrap(
        const GlassCard(child: Text('Blur')),
      ));
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });

  group('GlassCardSmall', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(_wrap(
        const GlassCardSmall(child: Text('Small')),
      ));
      expect(find.text('Small'), findsOneWidget);
    });

    testWidgets('applies backdrop filter', (tester) async {
      await tester.pumpWidget(_wrap(
        const GlassCardSmall(child: Text('Blur')),
      ));
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });
}
