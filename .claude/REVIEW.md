# Skill: Code Review (Flutter App)

## Purpose

Review Flutter/Dart code for bugs, performance issues, state management problems, UX regressions, and deviation from project conventions.

## Review checklist

### Widget structure
- [ ] `const` constructors used wherever possible. Missing `const` on stateless widgets causes unnecessary rebuilds.
- [ ] Widget tree depth is reasonable. If a `build()` method is over 80 lines, extract child widgets.
- [ ] No business logic in `build()` methods. Build should only describe UI — logic belongs in providers or callbacks.
- [ ] Widgets that depend on providers use `ConsumerWidget` / `ConsumerStatefulWidget`, not `StatefulWidget` with manual provider access.
- [ ] `ref.watch()` is used for reactive rebuilds, `ref.read()` for one-time actions (like button taps). Never `ref.watch()` inside callbacks.

### State management (Riverpod)
- [ ] Providers are properly scoped. Game state shouldn't persist after navigating away from the game screen.
- [ ] No provider is doing too much. If a provider manages 5+ independent pieces of state, split it.
- [ ] Async providers handle loading, error, and data states. `.when()` is used with all three callbacks.
- [ ] WebSocket messages flow through the provider layer, not directly to widgets.
- [ ] `ref.invalidate()` is called when state needs to be reset (e.g., starting a new game).

### Navigation (go_router)
- [ ] All routes are defined in `routes.dart`, not scattered across the app.
- [ ] Auth guard redirects unauthenticated users to the welcome screen.
- [ ] Game screen cannot be accessed without an active match. Guard against deep-link or back-button edge cases.
- [ ] Back button behavior is intentional on every screen. During gameplay, back should confirm before quitting.
- [ ] Route transitions use appropriate animations (slide, fade) consistent with the design.

### Performance
- [ ] No unnecessary rebuilds. Use `select()` on Riverpod providers to watch only the specific field that matters.
- [ ] Images and avatars are cached. Default SVG avatars should be rendered as widgets, not loaded from assets on every build.
- [ ] Lists use `ListView.builder` (lazy) not `ListView` (eager) for scrollable content (friend list, match history, round breakdown).
- [ ] Animation controllers are properly disposed in `dispose()`. Leaked controllers cause memory leaks.
- [ ] Heavy operations (JSON parsing, data transformation) happen in providers, not in `build()`.
- [ ] The game screen doesn't do any layout computation that could drop frames during the critical question → answer → reveal cycle.

### WebSocket handling
- [ ] Pong responses to server pings are sent IMMEDIATELY. No await, no processing, no logging that could delay it. This directly affects scoring fairness.
- [ ] WebSocket reconnection uses exponential backoff with jitter.
- [ ] Connection state is exposed as a provider. The UI shows a reconnecting indicator when disconnected.
- [ ] Incoming messages are deserialized into typed Dart objects, not left as raw JSON maps.
- [ ] `friend_presence` messages update the friends provider in real-time.
- [ ] `opponent_answered` messages update the game provider to show the answered indicator.
- [ ] The WebSocket client handles receiving a message for a game that's already ended (race condition on slow networks).

### Game screen specifics
- [ ] Timer countdown starts from the RECEIVED `timeout_ms`, not a hardcoded value.
- [ ] Option buttons are disabled after tapping one (no double-submit).
- [ ] The selected option is visually distinct BEFORE the server responds with round_result.
- [ ] After round_result: correct option shows green, incorrect selected option shows red, unselected options dim.
- [ ] The opponent's choice is rendered on the correct option (using `their_choice` mapped to YOUR shuffle).
- [ ] Score animations (point additions) run after the reveal, not during.
- [ ] The suspense pause (~800ms) between "both answered" and "reveal" is implemented as an intentional delay, not a loading state.
- [ ] Between rounds, the question card exit and enter animations don't overlap or flash.

### Design fidelity
- [ ] Colors match the design system (CSS vars from wireframes: --bg-deep, --amber-glow, --signal-green, etc. mapped to Flutter theme).
- [ ] Typography uses the correct fonts (DM Serif Display for headings, Bricolage Grotesque for body, Geist Mono for data).
- [ ] Spacing is consistent — use the design system's spacing scale, not arbitrary pixel values.
- [ ] Dark mode is the default. All colours should work on dark backgrounds. No hardcoded light-mode colors.
- [ ] Glass card effect (subtle background blur + low-opacity border) is used for cards as shown in wireframes.
- [ ] Option buttons have the correct border radius (16px) and padding from the wireframes.
- [ ] The timer ring matches the wireframe style (circular, depleting, amber color with urgency shift).

### Haptic feedback
- [ ] Option tap: `HapticFeedback.mediumImpact()` fires on tap, not on release.
- [ ] Correct answer reveal: `HapticFeedback.heavyImpact()`.
- [ ] Wrong answer reveal: `HapticFeedback.lightImpact()`.
- [ ] Countdown numbers (3, 2, 1): `HapticFeedback.heavyImpact()` on each.
- [ ] Haptics are NOT fired during automated state changes (loading, navigation) — only on user actions and game events.

### Accessibility (basics for MVP)
- [ ] All interactive elements have semantic labels for screen readers.
- [ ] Tap targets are at least 48x48 logical pixels.
- [ ] Text contrast meets WCAG AA on the dark background.
- [ ] Animations respect `MediaQuery.disableAnimations` / reduced motion preferences.

## Output format

For each issue:
```
[SEVERITY] file.dart:widget/function — Description
  Suggestion: How to fix it
```

Severity levels:
- **CRITICAL**: Scoring bugs, state leaks, broken game flow, haptic timing issues
- **WARNING**: Performance issues, state management anti-patterns, design mismatches
- **NITPICK**: Style preferences, minor improvements
