import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/option_button.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('OptionButton', () {
    testWidgets('renders letter and text', (tester) async {
      await tester.pumpWidget(_wrap(
        OptionButton(
          letter: 'A',
          text: 'Pacific Ocean',
          state: OptionState.default_,
          onTap: () {},
        ),
      ));
      expect(find.text('A'), findsOneWidget);
      expect(find.text('Pacific Ocean'), findsOneWidget);
    });

    testWidgets('calls onTap in default state', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        OptionButton(
          letter: 'B',
          text: 'Atlantic Ocean',
          state: OptionState.default_,
          onTap: () => tapped = true,
        ),
      ));
      await tester.tap(find.text('Atlantic Ocean'));
      expect(tapped, isTrue);
    });

    testWidgets('does not call onTap in selected state', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        OptionButton(
          letter: 'A',
          text: 'Pacific Ocean',
          state: OptionState.selected,
          onTap: () => tapped = true,
        ),
      ));
      await tester.tap(find.text('Pacific Ocean'));
      expect(tapped, isFalse);
    });

    testWidgets('does not call onTap in correct state', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        OptionButton(
          letter: 'C',
          text: 'Indian Ocean',
          state: OptionState.correct,
          onTap: () => tapped = true,
        ),
      ));
      await tester.tap(find.text('Indian Ocean'));
      expect(tapped, isFalse);
    });

    testWidgets('renders avatars when provided', (tester) async {
      await tester.pumpWidget(_wrap(
        const OptionButton(
          letter: 'A',
          text: 'Answer',
          state: OptionState.correct,
          playerAvatar: SizedBox(
            key: Key('player'),
            width: 22,
            height: 22,
          ),
        ),
      ));
      expect(find.byKey(const Key('player')), findsOneWidget);
    });

    testWidgets('dimmed state reduces opacity', (tester) async {
      await tester.pumpWidget(_wrap(
        const OptionButton(
          letter: 'D',
          text: 'Dimmed',
          state: OptionState.dimmed,
        ),
      ));
      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, 0.3);
    });

    testWidgets('press animation scales down in default state',
        (tester) async {
      await tester.pumpWidget(_wrap(
        OptionButton(
          letter: 'A',
          text: 'Press me',
          state: OptionState.default_,
          onTap: () {},
        ),
      ));

      final gesture =
          await tester.startGesture(tester.getCenter(find.text('Press me')));
      await tester.pump(const Duration(milliseconds: 50));

      final animatedScale =
          tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(animatedScale.scale, 0.97);

      await gesture.up();
      await tester.pumpAndSettle();
    });
  });
}
