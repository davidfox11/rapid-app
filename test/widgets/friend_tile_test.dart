import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rapid_app/widgets/friend_tile.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('FriendTile', () {
    testWidgets('renders name and username', (tester) async {
      await tester.pumpWidget(_wrap(
        const FriendTile(
          avatar: SizedBox(width: 42, height: 42),
          name: 'Sarah Connor',
          username: '@sconnor',
        ),
      ));
      expect(find.text('Sarah Connor'), findsOneWidget);
      expect(find.text('@sconnor'), findsOneWidget);
    });

    testWidgets('shows subtitle instead of username when provided',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const FriendTile(
          avatar: SizedBox(width: 42, height: 42),
          name: 'John Doe',
          username: '@jdoe',
          subtitle: 'Last seen 2h ago',
        ),
      ));
      expect(find.text('Last seen 2h ago'), findsOneWidget);
      expect(find.text('@jdoe'), findsNothing);
    });

    testWidgets('renders trailing widget', (tester) async {
      await tester.pumpWidget(_wrap(
        const FriendTile(
          avatar: SizedBox(width: 42, height: 42),
          name: 'Test',
          username: '@test',
          trailing: Text('Challenge'),
        ),
      ));
      expect(find.text('Challenge'), findsOneWidget);
    });

    testWidgets('responds to onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        FriendTile(
          avatar: const SizedBox(width: 42, height: 42),
          name: 'Tap Test',
          username: '@tap',
          onTap: () => tapped = true,
        ),
      ));
      await tester.tap(find.text('Tap Test'));
      expect(tapped, isTrue);
    });
  });
}
