import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:rapid_app/config/routes.dart';

void main() {
  group('Router', () {
    test('has all expected routes', () {
      final paths = router.configuration.routes
          .whereType<GoRoute>()
          .map((r) => r.path)
          .toList();

      expect(paths, contains('/'));
      expect(paths, contains('/home'));
      expect(paths, contains('/profile-setup'));
      expect(paths, contains('/add-friend'));
      expect(paths, contains('/select-opponent'));
      expect(paths, contains('/category-select'));
      expect(paths, contains('/waiting-lobby'));
      expect(paths, contains('/countdown'));
      expect(paths, contains('/gameplay'));
      expect(paths, contains('/game-summary'));
    });

    testWidgets('authenticated user redirects from / to /home',
        (tester) async {
      isAuthenticated = true;
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();
      // Should show Hub placeholder
      expect(find.text('Hub'), findsOneWidget);
    });

    testWidgets('unauthenticated user stays on /', (tester) async {
      isAuthenticated = false;
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();
      expect(find.text('Welcome'), findsOneWidget);
      // Reset for other tests
      isAuthenticated = true;
    });
  });
}
