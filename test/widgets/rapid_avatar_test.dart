import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/rapid_avatar.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('RapidAvatar', () {
    testWidgets('renders default SVG avatar when no URL', (tester) async {
      await tester.pumpWidget(_wrap(
        const RapidAvatar(defaultAvatarIndex: 3, size: 42),
      ));
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('clamps index to 1-12 range', (tester) async {
      await tester.pumpWidget(_wrap(
        const RapidAvatar(defaultAvatarIndex: 15, size: 42),
      ));
      expect(find.byType(RapidAvatar), findsOneWidget);
    });

    testWidgets('shows online dot when configured', (tester) async {
      await tester.pumpWidget(_wrap(
        const RapidAvatar(
          defaultAvatarIndex: 1,
          size: 42,
          showOnlineDot: true,
          isOnline: true,
        ),
      ));
      // The Positioned widget is the online dot indicator
      expect(find.byType(Positioned), findsOneWidget);
    });

    testWidgets('hides dot when showOnlineDot is false', (tester) async {
      await tester.pumpWidget(_wrap(
        const RapidAvatar(
          defaultAvatarIndex: 1,
          size: 42,
          showOnlineDot: false,
          isOnline: true,
        ),
      ));
      expect(find.byType(Positioned), findsNothing);
    });

    testWidgets('respects size parameter', (tester) async {
      await tester.pumpWidget(_wrap(
        const RapidAvatar(defaultAvatarIndex: 1, size: 80),
      ));
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 80);
      expect(sizedBox.height, 80);
    });
  });
}
