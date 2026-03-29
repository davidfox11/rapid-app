# Skill: Test & Self-Iterate (Flutter App)

## Purpose

Validate that screens, widgets, animations, state management, and server communication work correctly. Flutter testing has unique challenges — widget tests, golden tests, and the fact that animations and haptics can't be fully tested in headless mode. This skill defines what CAN be automated and what needs manual verification.

## Testing layers

### 1. Unit tests (providers, models, services)

Test business logic and data transformation. These run headlessly and fast.

```dart
// test/models/scoring_test.dart
void main() {
  group('Score calculation', () {
    test('instant correct answer gets max points', () {
      expect(computePoints(0, true), 1000);
    });

    test('correct answer at 5 seconds gets 500 points', () {
      expect(computePoints(5000, true), 500);
    });

    test('incorrect answer always gets 0', () {
      expect(computePoints(1000, false), 0);
    });

    test('timeout gets 0', () {
      expect(computePoints(15000, true), 0);
    });
  });
}
```

Key areas to unit test:
- **Model deserialization**: Every `fromJson` factory correctly parses server responses. Include edge cases: null fields, missing optional fields, unexpected extra fields.
- **WebSocket message parsing**: Raw JSON → typed Dart objects for every message type.
- **Provider logic**: Game state transitions (waiting → playing → round_result → next_round → game_end). Test that state resets properly between games.
- **Timer logic**: Countdown computation, urgency threshold (last 5 seconds flag).
- **Avatar resolution**: Given avatar_url and default_avatar_index, correct display logic.

Run with: `flutter test`

### 2. Widget tests (UI rendering and interaction)

Test that widgets render correctly and respond to interaction. These run in a headless test environment with a simulated Flutter framework.

```dart
// test/widgets/option_button_test.dart
void main() {
  testWidgets('option button shows text and letter', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OptionButton(
            letter: 'A',
            text: 'Pacific Ocean',
            state: OptionState.defaultState,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('Pacific Ocean'), findsOneWidget);
  });

  testWidgets('option button calls onTap when pressed', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OptionButton(
            letter: 'B',
            text: 'Atlantic Ocean',
            state: OptionState.defaultState,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Atlantic Ocean'));
    expect(tapped, isTrue);
  });

  testWidgets('option button is disabled in selected state', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OptionButton(
            letter: 'A',
            text: 'Pacific Ocean',
            state: OptionState.selected, // Already selected
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Pacific Ocean'));
    expect(tapped, isFalse); // Should not fire when already selected
  });

  testWidgets('correct state shows green styling', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OptionButton(
            letter: 'B',
            text: 'Pacific Ocean',
            state: OptionState.correct,
            onTap: () {},
          ),
        ),
      ),
    );

    // Verify the container has the correct background color
    final container = tester.widget<Container>(find.byType(Container).first);
    // Assert green-tinted decoration
  });
}
```

Widget tests to write:
- **OptionButton**: All 6 states (default, pressed, selected, correct, wrong+selected, wrong+unselected, dimmed)
- **CountdownTimer**: Renders correct time value, urgency state triggers at 5 seconds
- **ScoreBar**: Displays both players' scores, avatars, and round indicator
- **QuestionCard**: Renders question text, handles long text gracefully
- **FriendTile**: Online/offline/in_match states render correctly, challenge button visibility
- **RapidAvatar**: Photo URL renders image, null URL renders correct default SVG by index
- **RoundResultCard**: Correct/wrong indicators, time display, question text

### 3. Provider/integration tests

Test the full state flow with mocked services:

```dart
// test/providers/game_provider_test.dart
void main() {
  test('game provider transitions through round lifecycle', () async {
    final container = ProviderContainer(overrides: [
      wsClientProvider.overrideWithValue(MockWsClient()),
    ]);

    final gameNotifier = container.read(gameProvider.notifier);

    // Simulate receiving a question
    gameNotifier.handleMessage(WebSocketMessage(
      type: 'question',
      payload: {'round': 1, 'text': 'Test?', 'options': ['A', 'B', 'C', 'D'], 'timeout_ms': 15000},
    ));

    final state = container.read(gameProvider);
    expect(state.currentRound, 1);
    expect(state.phase, GamePhase.answering);
    expect(state.timerRunning, isTrue);

    // Simulate answering
    gameNotifier.submitAnswer(1);
    expect(container.read(gameProvider).phase, GamePhase.waitingForOpponent);

    // Simulate opponent answered
    gameNotifier.handleMessage(WebSocketMessage(
      type: 'opponent_answered',
      payload: {'round': 1},
    ));

    // Simulate round result
    gameNotifier.handleMessage(WebSocketMessage(
      type: 'round_result',
      payload: {
        'round': 1, 'your_choice': 1, 'your_correct': true, 'your_points': 850,
        'their_choice': 2, 'their_correct': false, 'their_points': 0,
        'your_total': 850, 'their_total': 0, 'correct_index': 1,
        'your_time_ms': 1500, 'their_time_ms': 3200,
      },
    ));

    final resultState = container.read(gameProvider);
    expect(resultState.phase, GamePhase.showingResult);
    expect(resultState.yourScore, 850);
    expect(resultState.theirScore, 0);
  });

  test('game state resets cleanly for new match', () async {
    // Play a full game, then start a new one
    // Verify no stale state from previous match
  });
}
```

### 4. Animation verification (manual + golden tests)

Animations cannot be fully tested headlessly, but you CAN verify:

**Golden tests** capture a screenshot of the widget at specific points in an animation and compare against a reference image:

```dart
testWidgets('question card entrance animation', (tester) async {
  await tester.pumpWidget(buildTestApp(QuestionCard(text: 'Test question?')));

  // Frame 0: card should be invisible/offscreen
  await expectLater(find.byType(QuestionCard), matchesGoldenFile('question_card_start.png'));

  // Advance animation to completion
  await tester.pumpAndSettle();

  // Final frame: card should be fully visible
  await expectLater(find.byType(QuestionCard), matchesGoldenFile('question_card_end.png'));
});
```

**Manual verification checklist** (test on a real device):
- [ ] Question card slides in smoothly (no jank, consistent 60fps)
- [ ] Option press animation feels responsive (scale down on finger contact, not on release)
- [ ] Timer ring depletes smoothly, colour shifts in last 5 seconds
- [ ] Score count-up animation decelerates naturally at the end
- [ ] Suspense pause after both answer feels intentional, not laggy
- [ ] Correct/wrong reveal animations play in sequence (not simultaneously)
- [ ] 3-2-1 countdown has weight — each number scales and fades with impact
- [ ] Screen transitions between question rounds are seamless (no flash, no layout shift)
- [ ] Victory/defeat screen animation plays once, doesn't loop annoyingly
- [ ] Friend list scrolls smoothly with many entries

### 5. Haptic verification (manual only, real device required)

Haptics CANNOT be tested in simulators or headless tests. Create a haptic test screen (hidden behind a debug flag) that lets you trigger each haptic event:

```dart
// Only in debug builds
class HapticTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => HapticFeedback.mediumImpact(),
          child: Text('Option tap'),
        ),
        ElevatedButton(
          onPressed: () => HapticFeedback.heavyImpact(),
          child: Text('Correct answer'),
        ),
        ElevatedButton(
          onPressed: () => HapticFeedback.lightImpact(),
          child: Text('Wrong answer'),
        ),
        ElevatedButton(
          onPressed: () => HapticFeedback.heavyImpact(),
          child: Text('Countdown beat'),
        ),
        ElevatedButton(
          onPressed: () => HapticFeedback.selectionClick(),
          child: Text('Timer tick (last 5s)'),
        ),
      ],
    );
  }
}
```

Test on BOTH iOS and Android — haptic feel differs significantly between platforms.

### 6. WebSocket integration test (against live server)

Run the Go server locally (docker compose up), then run the Flutter app against it:

```dart
// test/integration/full_game_test.dart
// This test requires the Go server running at localhost:8080
void main() {
  test('full game flow against live server', () async {
    // Register two test users via REST
    final api = ApiClient(baseUrl: 'http://localhost:8080');
    await api.register('test_player1', 'Player 1');
    await api.register('test_player2', 'Player 2');

    // Create friendships
    await api.sendFriendRequest('test_player1', 'test_player2');
    await api.acceptFriendRequest('test_player2', friendshipId);

    // Connect WebSockets
    final ws1 = WsClient('ws://localhost:8080/ws?user_id=test_player1');
    final ws2 = WsClient('ws://localhost:8080/ws?user_id=test_player2');
    await ws1.connect();
    await ws2.connect();

    // Player 1 challenges
    ws1.send('challenge', {'opponent_id': 'test_player2', 'category_id': 'general-knowledge'});

    // Player 2 accepts
    final challenge = await ws2.messages.firstWhere((m) => m.type == 'challenge_recv');
    ws2.send('challenge_resp', {
      'match_id': challenge.payload['match_id'],
      'challenger_id': 'test_player1',
      'category_id': 'general-knowledge',
      'accepted': true,
    });

    // Both receive game_start
    final gs1 = await ws1.messages.firstWhere((m) => m.type == 'game_start');
    final gs2 = await ws2.messages.firstWhere((m) => m.type == 'game_start');
    expect(gs1.payload['total_rounds'], 10);

    // Play all rounds
    for (int round = 1; round <= 10; round++) {
      final q1 = await ws1.messages.firstWhere((m) => m.type == 'question');
      final q2 = await ws2.messages.firstWhere((m) => m.type == 'question');

      // Same question text
      expect(q1.payload['text'], q2.payload['text']);
      // Options may be in different order (shuffled)

      ws1.send('answer', {'round': round, 'choice': 0});
      ws2.send('answer', {'round': round, 'choice': 0});

      final r1 = await ws1.messages.firstWhere((m) => m.type == 'round_result');
      final r2 = await ws2.messages.firstWhere((m) => m.type == 'round_result');

      // Scores should be consistent
      expect(r1.payload['your_total'] + r1.payload['their_total'],
             r2.payload['your_total'] + r2.payload['their_total']);
    }

    // Game end
    final end1 = await ws1.messages.firstWhere((m) => m.type == 'game_end');
    final end2 = await ws2.messages.firstWhere((m) => m.type == 'game_end');

    // Results should be complementary
    if (end1.payload['result'] == 'win') {
      expect(end2.payload['result'], 'loss');
    }

    await ws1.close();
    await ws2.close();
  });
}
```

### 7. Self-iteration loop

When something doesn't work:
1. Check the Flutter console for errors (red screen of death, exceptions, print statements)
2. Check `flutter analyze` for static analysis warnings
3. If a provider state issue: add `print()` or use Riverpod's `ProviderObserver` to log state changes
4. If an animation issue: slow down the animation (multiply duration by 10x) to see what's happening frame by frame
5. If a WebSocket issue: check the Go server logs (`docker compose logs server`) for the other side of the story
6. Fix, hot reload, verify. If hot reload doesn't pick up the change, hot restart.
7. Run `flutter test` after fixing to check for regressions.

## Key invariants to verify

- Game screen renders within one frame of receiving a question message
- Option tap → visual feedback happens within one frame (no perceptible delay)
- Pong response fires within 1ms of receiving ping (no awaits between receive and send)
- Timer starts counting from the moment the question is received, not from render
- Score totals in the UI match the cumulative round_result totals from the server
- After game_end, navigating to results screen shows correct data and "Play again" works
- Default avatars render identically to the wireframe SVGs for all 12 indices
- All text is readable on the dark background (no dark-on-dark accidents)
