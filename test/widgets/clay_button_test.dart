import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/clay_button.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: Center(child: child)));
}

void main() {
  group('ClayButton', () {
    testWidgets('renders label in uppercase', (tester) async {
      await tester.pumpWidget(_wrap(
        ClayButton(label: 'play', onPressed: () {}),
      ));
      expect(find.text('PLAY'), findsOneWidget);
    });

    testWidgets('calls onPressed on tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        ClayButton(label: 'tap me', onPressed: () => tapped = true),
      ));
      await tester.tap(find.text('TAP ME'));
      expect(tapped, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        const ClayButton(label: 'disabled'),
      ));
      await tester.tap(find.text('DISABLED'));
      expect(tapped, isFalse);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(_wrap(
        ClayButton(
          label: 'go',
          icon: const Icon(Icons.bolt),
          onPressed: () {},
        ),
      ));
      expect(find.byIcon(Icons.bolt), findsOneWidget);
    });

    testWidgets('press animation scales down', (tester) async {
      await tester.pumpWidget(_wrap(
        ClayButton(label: 'press', onPressed: () {}),
      ));

      // Tap down
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('PRESS')),
      );
      await tester.pump(const Duration(milliseconds: 50));

      // Find AnimatedScale and check it's scaling
      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(animatedScale.scale, 0.97);

      await gesture.up();
      await tester.pumpAndSettle();
    });
  });

  group('ClayButtonSecondary', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(_wrap(
        ClayButtonSecondary(label: 'cancel', onPressed: () {}),
      ));
      expect(find.text('CANCEL'), findsOneWidget);
    });
  });

  group('ClayButtonDanger', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(_wrap(
        ClayButtonDanger(label: 'delete', onPressed: () {}),
      ));
      expect(find.text('DELETE'), findsOneWidget);
    });
  });
}
