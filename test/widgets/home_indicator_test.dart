import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/home_indicator.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('HomeIndicator', () {
    testWidgets('renders widget', (tester) async {
      await tester.pumpWidget(_wrap(const HomeIndicator()));
      expect(find.byType(HomeIndicator), findsOneWidget);
    });
  });
}
