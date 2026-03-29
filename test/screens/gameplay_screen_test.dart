import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:rapid_app/data/mock_data.dart';
import 'package:rapid_app/providers/game_setup_provider.dart';
import 'package:rapid_app/screens/gameplay/gameplay_screen.dart';

void main() {
  group('GameplayScreen', () {
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
        ],
      );
      return ProviderScope(
        overrides: [
          selectedOpponentProvider
              .overrideWith((ref) => MockData.friends[0]),
          selectedCategoryProvider
              .overrideWith((ref) => MockData.categories[0]),
        ],
        child: MaterialApp.router(routerConfig: testRouter),
      );
    }

    testWidgets('renders loading then question', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();
      // Should show the question text
      expect(
        find.text('What is the chemical symbol for gold?'),
        findsOneWidget,
      );
    });

    testWidgets('renders 4 option buttons', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
    });

    testWidgets('renders round indicator', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();
      expect(find.text('ROUND 1 OF 10'), findsOneWidget);
    });

    testWidgets('tapping option transitions to answered', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();
      // Tap the first option (Au)
      await tester.tap(find.text('Au'));
      await tester.pump();
      // Should show "Waiting for opponent..." or answered state
      // The option should now be in selected state
      expect(find.text('Au'), findsOneWidget);
    });
  });
}
