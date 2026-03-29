import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:rapid_app/screens/onboarding/welcome_screen.dart';

void main() {
  group('WelcomeScreen', () {
    Widget buildTestApp() {
      final testRouter = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const WelcomeScreen(),
          ),
          GoRoute(
            path: '/profile-setup',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Profile Setup'))),
          ),
        ],
      );
      return MaterialApp.router(routerConfig: testRouter);
    }

    testWidgets('renders wordmark and tagline', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('Rapid.'), findsOneWidget);
      expect(find.text('THE DIGITAL PUB'), findsOneWidget);
    });

    testWidgets('renders both auth buttons', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('Continue with Apple'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
    });

    testWidgets('renders lightning bolt icon', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.byIcon(Icons.bolt), findsOneWidget);
    });

    testWidgets('tapping Apple button navigates to profile setup',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.tap(find.text('Continue with Apple'));
      // Wait for the mock delay
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text('Profile Setup'), findsOneWidget);
    });
  });
}
