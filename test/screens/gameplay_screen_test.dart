import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:rapid_app/data/mock_data.dart';
import 'package:rapid_app/models/game_state.dart';
import 'package:rapid_app/providers/game_provider.dart';
import 'package:rapid_app/providers/game_setup_provider.dart';
import 'package:rapid_app/screens/gameplay/gameplay_screen.dart';

void main() {
  group('GameplayScreen', () {
    late ProviderContainer container;

    Widget buildTestApp() {
      final testRouter = GoRouter(
        initialLocation: '/gameplay',
        routes: [
          GoRoute(
            path: '/gameplay',
            builder: (_, __) => const GameplayScreen(),
          ),
          GoRoute(
            path: '/game-summary',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Summary'))),
          ),
          GoRoute(
            path: '/home',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Home'))),
          ),
        ],
      );
      container = ProviderContainer(overrides: [
        selectedOpponentProvider.overrideWith((ref) => MockData.friends[0]),
        selectedCategoryProvider
            .overrideWith((ref) => MockData.categories[0]),
      ]);
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: testRouter),
      );
    }

    testWidgets('renders preview with question and round indicator',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump(); // postFrameCallback fires
      await tester.pump(const Duration(milliseconds: 100));

      final game = container.read(gameProvider);
      expect(game, isNotNull);
      expect(game!.phase, GamePhase.preview);
      expect(
        find.text('What is the chemical symbol for gold?'),
        findsOneWidget,
      );
      expect(find.text('ROUND 1 OF 10'), findsOneWidget);

      container.read(gameProvider.notifier).endGame();
      await tester.pump();
    });

    testWidgets('transitions to active phase with options', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump(); // postFrameCallback fires

      // Pump past preview -> active transition (2000ms) plus
      // flutter_animate delays and opponent timer
      await tester.pump(const Duration(milliseconds: 2100));
      // Settle animate widgets (their Future.delayed(delay) fires)
      await tester.pump(const Duration(milliseconds: 500));

      final game = container.read(gameProvider);
      expect(game!.phase, GamePhase.active);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);

      // Cancel game timers, then settle animation timers
      container.read(gameProvider.notifier).endGame();
      await tester.pumpAndSettle();
    });

    testWidgets('tapping option changes to answered phase', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      // Get to active phase and let animations settle
      await tester.pump(const Duration(milliseconds: 2100));
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.text('Au'));
      await tester.pump();
      expect(find.text('Au'), findsOneWidget);

      final game = container.read(gameProvider);
      expect(game!.phase, GamePhase.answered);

      container.read(gameProvider.notifier).endGame();
      await tester.pumpAndSettle();
    });
  });
}
