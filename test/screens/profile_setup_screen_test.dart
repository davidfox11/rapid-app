import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:rapid_app/screens/onboarding/profile_setup_screen.dart';

void main() {
  group('ProfileSetupScreen', () {
    Widget buildTestApp() {
      final testRouter = GoRouter(
        initialLocation: '/profile-setup',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Welcome'))),
          ),
          GoRoute(
            path: '/profile-setup',
            builder: (_, __) => const ProfileSetupScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Hub'))),
          ),
        ],
      );
      return MaterialApp.router(routerConfig: testRouter);
    }

    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.textContaining('Welcome to'), findsOneWidget);
      expect(find.textContaining('set up your profile'), findsOneWidget);
    });

    testWidgets('renders avatar SVG', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('renders display name and username fields', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('DISPLAY NAME'), findsOneWidget);
      expect(find.text('USERNAME'), findsOneWidget);
    });

    testWidgets('continue button disabled initially', (tester) async {
      await tester.pumpWidget(buildTestApp());
      // The ClayButton should be in disabled state (no onPressed)
      expect(find.textContaining('CONTINUE'), findsOneWidget);
    });

    testWidgets('username validation shows available for valid input',
        (tester) async {
      await tester.pumpWidget(buildTestApp());

      // Find username TextField (second one)
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      // Enter valid username
      await tester.enterText(textFields.last, 'alex_q');
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Username is available'), findsOneWidget);
    });

    testWidgets('username validation shows error for "taken"',
        (tester) async {
      await tester.pumpWidget(buildTestApp());

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.last, 'taken');
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Username is already taken'), findsOneWidget);
    });

    testWidgets('username validation shows error for short input',
        (tester) async {
      await tester.pumpWidget(buildTestApp());

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.last, 'ab');
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Must be at least 3 characters'), findsOneWidget);
    });
  });
}
