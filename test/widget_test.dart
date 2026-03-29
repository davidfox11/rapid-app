import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/config/routes.dart';

void main() {
  testWidgets('App boots to Hub via router', (WidgetTester tester) async {
    isAuthenticated = true;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('The Hub'), findsOneWidget);
  });
}
