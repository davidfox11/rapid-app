import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/timer_ring.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('TimerRing', () {
    testWidgets('renders remaining seconds as text', (tester) async {
      await tester.pumpWidget(_wrap(
        const TimerRing(totalSeconds: 15, remainingSeconds: 8),
      ));
      expect(find.text('8'), findsOneWidget);
    });

    testWidgets('renders CustomPaint for ring', (tester) async {
      await tester.pumpWidget(_wrap(
        const TimerRing(totalSeconds: 15, remainingSeconds: 10),
      ));
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('shows ceiling of fractional seconds', (tester) async {
      await tester.pumpWidget(_wrap(
        const TimerRing(totalSeconds: 15, remainingSeconds: 3.2),
      ));
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('respects size parameter', (tester) async {
      await tester.pumpWidget(_wrap(
        const TimerRing(totalSeconds: 15, remainingSeconds: 5, size: 100),
      ));
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 100);
    });
  });
}
