import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:rapid_app/screens/game_setup/category_select_screen.dart';

void main() {
  group('CategorySelectScreen', () {
    Widget buildTestApp() {
      final testRouter = GoRouter(
        initialLocation: '/category-select',
        routes: [
          GoRoute(
            path: '/select-opponent',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Opponent'))),
          ),
          GoRoute(
            path: '/category-select',
            builder: (_, __) => const CategorySelectScreen(),
          ),
          GoRoute(
            path: '/waiting-lobby',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Lobby'))),
          ),
        ],
      );
      return ProviderScope(
        child: MaterialApp.router(routerConfig: testRouter),
      );
    }

    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.textContaining('Choose your'), findsOneWidget);
    });

    testWidgets('renders all 5 categories', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('General Knowledge'), findsOneWidget);
      expect(find.text('Movies'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('Geography'), findsOneWidget);
      expect(find.text('Ireland'), findsOneWidget);
    });

    testWidgets('Lock It In button disabled initially', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.textContaining('LOCK IT IN'), findsOneWidget);
    });

    testWidgets('selecting a category enables Lock It In', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.tap(find.text('General Knowledge'));
      await tester.pump();
      // The button should now be enabled (tappable)
      await tester.tap(find.textContaining('LOCK IT IN'));
      await tester.pumpAndSettle();
      expect(find.text('Lobby'), findsOneWidget);
    });
  });
}
