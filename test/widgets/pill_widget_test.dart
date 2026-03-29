import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/pill_widget.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('Pill', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(_wrap(
        const Pill(label: 'Online', variant: PillVariant.green),
      ));
      expect(find.text('Online'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(_wrap(
        const Pill(
          label: 'Status',
          variant: PillVariant.amber,
          icon: Icon(Icons.star, size: 12),
        ),
      ));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('glass variant renders', (tester) async {
      await tester.pumpWidget(_wrap(
        const Pill(label: 'Round 3/10', variant: PillVariant.glass),
      ));
      expect(find.text('Round 3/10'), findsOneWidget);
    });
  });
}
