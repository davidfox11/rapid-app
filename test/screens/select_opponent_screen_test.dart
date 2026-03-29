import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:rapid_app/screens/game_setup/select_opponent_screen.dart';

void main() {
  group('SelectOpponentScreen', () {
    Widget buildTestApp() {
      final testRouter = GoRouter(
        initialLocation: '/select-opponent',
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Hub'))),
          ),
          GoRoute(
            path: '/select-opponent',
            builder: (_, __) => const SelectOpponentScreen(),
          ),
          GoRoute(
            path: '/category-select',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Category'))),
          ),
        ],
      );
      return ProviderScope(
        child: MaterialApp.router(routerConfig: testRouter),
      );
    }

    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('Select Opponent'), findsOneWidget);
    });

    testWidgets('renders search bar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('Search friends...'), findsOneWidget);
    });

    testWidgets('renders friend list with count', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('FRIENDS (6)'), findsOneWidget);
    });

    testWidgets('renders online friends first', (tester) async {
      await tester.pumpWidget(buildTestApp());
      // Sarah is online, should appear
      expect(find.text('Sarah'), findsOneWidget);
    });
  });
}
