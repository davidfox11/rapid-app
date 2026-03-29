import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/game_setup/category_select_screen.dart';
import '../screens/game_setup/countdown_screen.dart';
import '../screens/game_setup/select_opponent_screen.dart';
import '../screens/game_setup/waiting_lobby_screen.dart';
import '../screens/gameplay/gameplay_screen.dart';
import '../screens/home/hub_screen.dart';
import '../screens/postgame/game_summary_screen.dart';
import '../screens/onboarding/profile_setup_screen.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../screens/social/add_friend_screen.dart';

// Hardcoded for development — will be replaced by auth provider
bool isAuthenticated = true;

// ── Transition builders ────────────────────────────────

const _duration = Duration(milliseconds: 350);
const _fastDuration = Duration(milliseconds: 250);

CustomTransitionPage<void> _slideFromRight(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: _duration,
    reverseTransitionDuration: _duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

CustomTransitionPage<void> _fadeThrough(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: _fastDuration,
    reverseTransitionDuration: _fastDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeOut).animate(animation),
        child: child,
      );
    },
  );
}

CustomTransitionPage<void> _slideUp(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: _duration,
    reverseTransitionDuration: _duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: const Offset(0, 0.15), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOutCubic));
      final fadeTween = Tween(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOut));
      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}

// ── Router ─────────────────────────────────────────────

final router = GoRouter(
  initialLocation: '/home',
  redirect: (context, state) {
    if (!isAuthenticated && state.uri.path != '/') {
      return '/';
    }
    if (isAuthenticated && state.uri.path == '/') {
      return '/home';
    }
    return null;
  },
  routes: [
    // Onboarding — fade
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          _fadeThrough(state, const WelcomeScreen()),
    ),
    GoRoute(
      path: '/profile-setup',
      pageBuilder: (context, state) =>
          _slideFromRight(state, const ProfileSetupScreen()),
    ),

    // Hub — fade (feels like arriving home)
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) =>
          _fadeThrough(state, const HubScreen()),
    ),

    // Social — slide from right
    GoRoute(
      path: '/add-friend',
      pageBuilder: (context, state) =>
          _slideFromRight(state, const AddFriendScreen()),
    ),

    // Game setup — slide from right (linear flow)
    GoRoute(
      path: '/select-opponent',
      pageBuilder: (context, state) =>
          _slideFromRight(state, const SelectOpponentScreen()),
    ),
    GoRoute(
      path: '/category-select',
      pageBuilder: (context, state) =>
          _slideFromRight(state, const CategorySelectScreen()),
    ),

    // Lobby → Countdown → Gameplay — fade (cinematic)
    GoRoute(
      path: '/waiting-lobby',
      pageBuilder: (context, state) =>
          _fadeThrough(state, const WaitingLobbyScreen()),
    ),
    GoRoute(
      path: '/countdown',
      pageBuilder: (context, state) =>
          _fadeThrough(state, const CountdownScreen()),
    ),
    GoRoute(
      path: '/gameplay',
      pageBuilder: (context, state) =>
          _fadeThrough(state, const GameplayScreen()),
    ),

    // Post-game — slide up (results reveal)
    GoRoute(
      path: '/game-summary',
      pageBuilder: (context, state) =>
          _slideUp(state, const GameSummaryScreen()),
    ),
  ],
);
