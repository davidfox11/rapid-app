import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/onboarding/profile_setup_screen.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../theme/app_typography.dart';
import '../widgets/screen_background.dart';

// Hardcoded for development — will be replaced by auth provider
bool isAuthenticated = true;

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
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const _Placeholder('Hub'),
    ),
    GoRoute(
      path: '/add-friend',
      builder: (context, state) => const _Placeholder('Add Friend'),
    ),
    GoRoute(
      path: '/select-opponent',
      builder: (context, state) => const _Placeholder('Select Opponent'),
    ),
    GoRoute(
      path: '/category-select',
      builder: (context, state) => const _Placeholder('Category Select'),
    ),
    GoRoute(
      path: '/waiting-lobby',
      builder: (context, state) => const _Placeholder('Waiting Lobby'),
    ),
    GoRoute(
      path: '/countdown',
      builder: (context, state) => const _Placeholder('Countdown'),
    ),
    GoRoute(
      path: '/gameplay',
      builder: (context, state) => const _Placeholder('Gameplay'),
    ),
    GoRoute(
      path: '/game-summary',
      builder: (context, state) => const _Placeholder('Game Summary'),
    ),
  ],
);

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.name);
  final String name;

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Center(
        child: Text(name, style: AppTypography.serifH(fontSize: 36)),
      ),
    );
  }
}
