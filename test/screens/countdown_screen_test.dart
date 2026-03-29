import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:rapid_app/screens/game_setup/countdown_screen.dart';

void main() {
  group('CountdownScreen', () {
    Widget buildTestApp() {
      final testRouter = GoRouter(
        initialLocation: '/countdown',
        routes: [
          GoRoute(
            path: '/countdown',
            builder: (_, __) => const CountdownScreen(),
          ),
          GoRoute(
            path: '/gameplay',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Gameplay'))),
          ),
        ],
      );
      return ProviderScope(
        child: MaterialApp.router(routerConfig: testRouter),
      );
    }

    testWidgets('starts at 3', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('transitions through 3-2-1', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('3'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 1100));
      expect(find.text('2'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 1000));
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('navigates to gameplay after countdown', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text('Gameplay'), findsOneWidget);
    });

    testWidgets('shows player context', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('You'), findsOneWidget);
      expect(find.text('vs'), findsOneWidget);
    });
  });
}
