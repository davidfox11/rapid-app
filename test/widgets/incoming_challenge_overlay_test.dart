import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/incoming_challenge_overlay.dart';

void main() {
  group('IncomingChallengeOverlay', () {
    testWidgets('showIncomingChallenge displays dialog', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => showIncomingChallenge(
                context,
                challengerName: 'TestUser',
                challengerAvatarIndex: 3,
                categoryName: 'Movies',
                h2hYou: 5,
                h2hThem: 3,
                onAccept: () {},
                onDecline: () {},
              ),
              child: const Text('Show'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Show'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('TestUser'), findsOneWidget);
      expect(find.text('wants to play!'), findsOneWidget);
      expect(find.textContaining('Movies'), findsOneWidget);
      expect(find.textContaining('ACCEPT'), findsOneWidget);
      expect(find.textContaining('DECLINE'), findsOneWidget);
    });

    testWidgets('accept callback fires', (tester) async {
      var accepted = false;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => showIncomingChallenge(
                context,
                challengerName: 'TestUser',
                challengerAvatarIndex: 3,
                categoryName: 'Movies',
                h2hYou: 5,
                h2hThem: 3,
                onAccept: () => accepted = true,
                onDecline: () {},
              ),
              child: const Text('Show'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Show'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.textContaining('ACCEPT'));
      await tester.pumpAndSettle();

      expect(accepted, isTrue);
    });
  });
}
