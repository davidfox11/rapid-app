import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:rapid_app/screens/postgame/game_summary_screen.dart';

void main() {
  group('GameSummaryScreen', () {
    testWidgets('shows "No game data" when game is null', (tester) async {
      final testRouter = GoRouter(
        initialLocation: '/game-summary',
        routes: [
          GoRoute(
            path: '/game-summary',
            builder: (_, __) => const GameSummaryScreen(),
          ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: testRouter),
        ),
      );
      // Settle the delayed animation start
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('No game data'), findsOneWidget);
    });
  });
}
