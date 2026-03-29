import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../providers/auth_provider.dart';
import '../../providers/game_setup_provider.dart';
import '../../widgets/clay_button.dart';
import '../../widgets/data_label.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/home_indicator.dart';
import '../../widgets/pill_widget.dart';
import '../../widgets/rapid_avatar.dart';
import '../../widgets/screen_background.dart';

class WaitingLobbyScreen extends ConsumerStatefulWidget {
  const WaitingLobbyScreen({super.key});

  @override
  ConsumerState<WaitingLobbyScreen> createState() =>
      _WaitingLobbyScreenState();
}

class _WaitingLobbyScreenState extends ConsumerState<WaitingLobbyScreen> {
  Timer? _autoAdvance;

  @override
  void initState() {
    super.initState();
    _autoAdvance = Timer(const Duration(seconds: 3), () {
      if (mounted) context.go('/countdown');
    });
  }

  @override
  void dispose() {
    _autoAdvance?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final opponent = ref.watch(selectedOpponentProvider);
    final category = ref.watch(selectedCategoryProvider);

    return ScreenBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text('Waiting Lobby',
                  style: AppTypography.serifH(fontSize: 22)),
              const SizedBox(height: 40),

              // VS layout
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // You
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.amberGlow, width: 3),
                        ),
                        child: RapidAvatar(
                          avatarUrl: user.avatarUrl,
                          defaultAvatarIndex: user.defaultAvatarIndex,
                          size: 84,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Pill(
                          label: '\u25CF Ready', variant: PillVariant.green),
                      const SizedBox(height: 6),
                      Text(
                        user.displayName,
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'VS',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 28,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                  // Opponent
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.glassStrokeLight,
                                width: 2,
                                // Dashed not available — solid is fine for now
                              ),
                            ),
                            child: ClipOval(
                              child: RapidAvatar(
                                avatarUrl: opponent?.avatarUrl,
                                defaultAvatarIndex:
                                    opponent?.defaultAvatarIndex ?? 1,
                                size: 84,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.amberGlow,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Pill(
                          label: 'Waiting...', variant: PillVariant.glass),
                      const SizedBox(height: 6),
                      Text(
                        opponent?.displayName ?? 'Opponent',
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Connection status
              GlassCardSmall(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.signalGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Excellent Connection',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.signalGreen,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '24ms',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: AppColors.signalGreen.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Match parameters
              const Align(
                alignment: Alignment.centerLeft,
                child: DataLabel('Match Parameters'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GlassCardSmall(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CATEGORY',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category?.name ?? 'General Knowledge',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GlassCardSmall(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FORMAT',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '10 Rounds',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Status message — breathing pulse
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.glassPanel,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.glassStroke),
                ),
                child: Text(
                  'Waiting for opponent to join...',
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .fadeIn(begin: 0.5, duration: 1500.ms, curve: Curves.easeInOut),

              const Spacer(),

              // Bottom buttons
              Row(
                children: [
                  Expanded(
                    child: ClayButtonSecondary(
                      label: 'Invite Link',
                      onPressed: () {},
                      isFullWidth: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClayButtonDanger(
                      label: 'Cancel',
                      onPressed: () => context.go('/home'),
                      isFullWidth: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const HomeIndicator(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
