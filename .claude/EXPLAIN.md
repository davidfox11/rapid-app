# Skill: Explain & Learn (Flutter/Dart)

## Purpose

After implementing a change, explain Flutter and Dart concepts in a way that helps David learn the framework. He's an experienced React/TypeScript developer — draw parallels, highlight differences, and provide references.

## When to use

After completing an implementation task, or when explicitly asked to explain a concept.

## Explanation structure

### 1. What changed (brief)
2-3 sentence summary.

### 2. Flutter/Dart concepts introduced or used

For each concept, explain:

**The concept**: What it is in one paragraph.

**React/TypeScript equivalent**:
- Flutter `StatelessWidget` → React functional component (no hooks)
- Flutter `StatefulWidget` → React functional component with `useState`
- Flutter `build()` method → React `render()` / the function body of a functional component
- Riverpod `ref.watch()` → React `useContext()` or `useSelector()` (triggers rebuild on change)
- Riverpod `ref.read()` → accessing a ref inside a callback, not subscribing to changes
- Riverpod `StateNotifierProvider` → Zustand store or useReducer
- `go_router` → React Router with route guards
- Flutter `Navigator.push()` → `history.push()` (imperative, avoid in favour of go_router's declarative approach)
- `AnimationController` → no direct equivalent; closest is manually managing requestAnimationFrame. Framer Motion's `useAnimation` is spiritually similar
- `flutter_animate` → closest to Framer Motion's declarative API
- Dart `Future` → JavaScript `Promise` (nearly identical)
- Dart `Stream` → RxJS Observable (subscribe, map, where, listen)
- Dart `async/await` → JavaScript async/await (identical syntax and semantics)
- Dart null safety (`String?`) → TypeScript strict null checks (`string | null`)
- Dart `final` → JavaScript `const` (immutable binding, not deeply frozen)
- Dart `const` → no JS equivalent. Compile-time constant. Flutter uses this for widget tree optimization.
- Dart `extension` → TypeScript doesn't have this. Adds methods to existing types without subclassing.
- Dart `sealed class` → TypeScript discriminated unions / tagged unions
- Dart `freezed` → similar to TypeScript's `readonly` + manual discriminated union, but with code generation

**Why Flutter does it this way**: The design philosophy.

**Common mistake from React developers**:
- Putting state logic in `build()` — equivalent of doing side effects in render
- Using `setState` everywhere instead of lifting state into Riverpod
- Trying to use CSS thinking for layouts — Flutter uses a box constraint model, not CSS flexbox (though `Row`/`Column` are similar)
- Expecting hot reload to work after changing state class shapes — need hot restart
- Creating deeply nested widget trees without extracting — this is actually normal in Flutter, but knowing WHEN to extract matters

### 3. Flutter animation system deep dive (when animations are involved)

Flutter's animation system has three layers:
1. **Implicit animations** (`AnimatedContainer`, `AnimatedOpacity`) — the easiest. Change a property and Flutter animates to the new value. Like CSS transitions.
2. **`flutter_animate`** — declarative chainable API. `.animate().fadeIn(duration: 300.ms).slideY(begin: 0.1)`. This is what we use for most Rapid animations.
3. **Explicit animations** (`AnimationController` + `Tween` + `AnimatedBuilder`) — full control. Like writing requestAnimationFrame manually. Use for the timer ring and custom game animations.

For each animation in the code, explain which layer is being used and why.

### 4. References

Prefer these resources:
- **Flutter documentation** (https://docs.flutter.dev/) — excellent tutorials and cookbooks
- **Flutter Widget of the Week** (YouTube) — 1-minute videos per widget, great for discovery
- **Riverpod documentation** (https://riverpod.dev/) — the official guide with examples
- **flutter_animate package docs** — for animation API reference
- **"Flutter in Action" by Eric Windmill** — comprehensive Flutter book
- **Dart language tour** (https://dart.dev/language) — for Dart-specific syntax questions
- **Flutter source code on GitHub** — Material widgets are well-documented and readable
- **Andrea Bizzotto's blog** (codewithandrea.com) — best Flutter architecture articles, particularly on Riverpod patterns

### 5. "If you have 10 minutes" challenge

A small exercise to reinforce the concept:
- "Try changing this implicit animation to an explicit one and notice the difference in control"
- "Add a `.shake()` animation to the wrong answer option using flutter_animate"
- "Convert this StatefulWidget to a ConsumerWidget with Riverpod and compare the code"
- "Add a spring curve to this animation and adjust the damping — feel how it changes"

## Tone

Peer-to-peer. David ships production software daily — he doesn't need basics explained. Focus on the surprising parts, the "ah that's different from React" moments, and the patterns that are uniquely Flutter.
