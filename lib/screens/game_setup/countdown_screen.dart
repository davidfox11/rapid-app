import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/game_setup_provider.dart';
import '../../widgets/data_label.dart';
import '../../widgets/rapid_avatar.dart';

class CountdownScreen extends ConsumerStatefulWidget {
  const CountdownScreen({super.key});

  @override
  ConsumerState<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends ConsumerState<CountdownScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentNumber = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller.addListener(_onTick);
    _controller.forward();
    HapticFeedback.heavyImpact();
  }

  void _onTick() {
    final elapsed = _controller.value * 3;
    int newNumber;
    if (elapsed < 1) {
      newNumber = 3;
    } else if (elapsed < 2) {
      newNumber = 2;
    } else {
      newNumber = 1;
    }

    if (newNumber != _currentNumber) {
      setState(() => _currentNumber = newNumber);
      HapticFeedback.heavyImpact();
    }

    if (_controller.isCompleted && mounted) {
      context.go('/gameplay');
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final opponent = ref.watch(selectedOpponentProvider);
    final category = ref.watch(selectedCategoryProvider);

    return DefaultTextStyle(
      style: const TextStyle(
        decoration: TextDecoration.none,
        color: AppColors.textPrimary,
      ),
      child: Container(
        color: const Color(0xFF050507),
        child: Stack(
          children: [
            // Amber radial glow
            Center(
              child: Container(
                width: 400,
                height: 400,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color.fromRGBO(255, 191, 94, 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Player context
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RapidAvatar(
                        avatarUrl: user.avatarUrl,
                        defaultAvatarIndex: user.defaultAvatarIndex,
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'You',
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'vs',
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                      Text(
                        opponent?.displayName ?? 'Opponent',
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      RapidAvatar(
                        avatarUrl: opponent?.avatarUrl,
                        defaultAvatarIndex:
                            opponent?.defaultAvatarIndex ?? 1,
                        size: 32,
                      ),
                    ],
                  ),

                  const Spacer(flex: 3),

                  // Countdown number
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      final elapsed = _controller.value * 3;
                      final beatProgress = elapsed - elapsed.floor();
                      final scale = 1.2 - (0.2 * beatProgress);

                      return Transform.scale(
                        scale: scale,
                        child: Text(
                          '$_currentNumber',
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 160,
                            color: Colors.white,
                            shadows: [
                              const Shadow(
                                color:
                                    Color.fromRGBO(255, 191, 94, 0.3),
                                blurRadius: 80,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 2),

                  // Match info
                  DataLabel(
                      '${category?.name ?? "General Knowledge"} \u00B7 10 Rounds'),
                  const SizedBox(height: 8),
                  Text(
                    'Get ready...',
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const Spacer(flex: 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
