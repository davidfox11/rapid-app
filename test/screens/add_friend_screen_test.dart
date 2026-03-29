import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:rapid_app/screens/social/add_friend_screen.dart';

void main() {
  group('AddFriendScreen', () {
    Widget buildTestApp() {
      final testRouter = GoRouter(
        initialLocation: '/add-friend',
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Hub'))),
          ),
          GoRoute(
            path: '/add-friend',
            builder: (_, __) => const AddFriendScreen(),
          ),
        ],
      );
      return ProviderScope(
        child: MaterialApp.router(routerConfig: testRouter),
      );
    }

    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('Add Friend'), findsOneWidget);
    });

    testWidgets('renders search bar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('Search by username...'), findsOneWidget);
    });

    testWidgets('renders share section', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('SHARE YOUR USERNAME'), findsOneWidget);
      expect(find.text('@davoc'), findsOneWidget);
    });

    testWidgets('search shows results', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.enterText(find.byType(TextField), 'sarah');
      await tester.pump();
      expect(find.text('RESULTS'), findsOneWidget);
      expect(find.text('Sarah'), findsOneWidget);
    });

    testWidgets('empty search shows no results section', (tester) async {
      await tester.pumpWidget(buildTestApp());
      // No query = no results section
      expect(find.text('RESULTS'), findsNothing);
    });

    testWidgets('search with no match shows no results message',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.enterText(find.byType(TextField), 'zzzzz');
      await tester.pump();
      expect(find.text('No results found'), findsOneWidget);
    });
  });
}
