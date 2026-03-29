# Skill: Conceptual Critique (Flutter App)

## Purpose

Before implementing a new screen, widget, or feature, evaluate how it fits into the existing app architecture, whether it follows Flutter/Dart conventions, and whether the UX matches the design intent.

## When to use

Before building a new screen, adding a provider, creating a custom widget, or changing navigation flow.

## Process

### 1. Understand the intent
- What user action does this enable?
- Which wireframe screen does this correspond to? Reference the screen number (01-12).
- Is this an MVP flow or a nice-to-have?

### 2. Evaluate widget architecture
- Is this a screen (full page in the router) or a component (reusable widget)?
- Does it need state? If yes, is Riverpod the right choice or can it be local `StatefulWidget` state?
  - Rule of thumb: if the state is UI-only (animation controllers, text field values, scroll position), use StatefulWidget. If it's shared across widgets or comes from the server, use Riverpod.
- Is it accessing providers correctly? `ConsumerWidget` for simple reads, `ConsumerStatefulWidget` only when lifecycle methods are needed.
- Is the widget tree reasonable? Flutter trees are deep, but if a single `build()` method exceeds ~80 lines, it should be decomposed into extracted widgets.

### 3. Evaluate state management
- Does this feature's state belong in an existing provider or need a new one?
- Is WebSocket state being handled reactively? The game provider should react to incoming messages via a Stream, not poll.
- Is there a clear data flow: server → WebSocket → provider → widget rebuild?
- On game end or navigation away, is state cleaned up? Stale game state from a previous match is a guaranteed bug source.
- Is optimistic UI being used where appropriate? (e.g., show option as "selected" immediately on tap, don't wait for server confirmation)

### 4. Evaluate against the design
- Does this match the wireframe's layout zones (top bar, timer, question, options)?
- Are all states accounted for? Every widget should handle: default, loading, error, empty, and success states.
- Is the animation timing matching the spec? (300ms question entrance, 800ms suspense pause, 1.5s score count-up, etc.)
- Is haptic feedback included for interactive elements?
- Does it work in dark mode? (Dark mode is the primary design — check all colours use the theme system.)

### 5. Evaluate navigation impact
- Does this screen need a route in go_router?
- Does it need an auth guard? (All screens except welcome/sign-in require authentication.)
- What happens if the user deep-links to this screen without the expected state? (e.g., opening a game screen without an active match)
- What's the back button behavior? During a game, back should probably show a "quit match?" confirmation, not silently navigate away.

### 6. Check for Rapid-specific concerns
- Does this affect the real-time game experience? The game screen must render incoming questions within one frame (~16ms) of receiving the WebSocket message.
- Is the pong response to server pings happening immediately? Any delay in the WebSocket client's pong response corrupts RTT measurement.
- Are option shuffles being handled correctly? The client receives pre-shuffled options — it should NOT re-shuffle them.
- Is the opponent's presence/status being shown accurately based on `friend_presence` and `opponent_answered` messages?
- Are the 12 default avatar SVGs rendering correctly for the given `default_avatar_index`?

## Output format

1. **Assessment**: 1-2 sentences on whether the approach is sound
2. **Concerns**: Specific issues ranked by severity
3. **Suggestions**: Alternative approaches or improvements
4. **Design alignment**: Whether the implementation matches the wireframes
5. **Verdict**: PROCEED / REVISE / RETHINK
