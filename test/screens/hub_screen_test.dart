import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/screens/home/hub_screen.dart';

void main() {
  group('HubScreen', () {
    Widget buildTestApp() {
      return const ProviderScope(
        child: MaterialApp(home: HubScreen()),
      );
    }

    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('The Hub'), findsOneWidget);
      expect(find.text('Ready for another round?'), findsOneWidget);
    });

    testWidgets('renders welcome back with username', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('WELCOME BACK'), findsOneWidget);
      expect(find.text('@davoc'), findsOneWidget);
    });

    testWidgets('renders challenge button', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.textContaining('CHALLENGE A FRIEND'), findsOneWidget);
    });

    testWidgets('renders social pulse section', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('SOCIAL PULSE'), findsOneWidget);
    });

    testWidgets('renders recent matches section', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('RECENT MATCHES'), findsOneWidget);
    });

    testWidgets('renders pub rating', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('1458'), findsOneWidget);
    });
  });
}
