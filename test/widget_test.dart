import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rapid_app/app.dart';

void main() {
  testWidgets('App renders widget catalog screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: RapidApp()));
    expect(find.text('Widget Catalog'), findsOneWidget);
  });
}
