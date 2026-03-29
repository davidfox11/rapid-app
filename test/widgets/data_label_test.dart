import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/data_label.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('DataLabel', () {
    testWidgets('renders label in uppercase', (tester) async {
      await tester.pumpWidget(_wrap(const DataLabel('hello world')));
      expect(find.text('HELLO WORLD'), findsOneWidget);
    });
  });
}
