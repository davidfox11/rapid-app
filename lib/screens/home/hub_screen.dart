import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../providers/auth_provider.dart';
import '../../providers/friends_provider.dart';
import '../../providers/matches_provider.dart';
import '../../widgets/clay_button.dart';
import '../../widgets/data_label.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/home_indicator.dart';
import '../../widgets/icon_circle.dart';
import '../../widgets/pill_widget.dart';
import '../../widgets/pub_rating_card.dart';
import '../../widgets/incoming_challenge_overlay.dart';
import '../../widgets/rapid_avatar.dart';
import '../../widgets/screen_background.dart';

class HubScreen extends ConsumerWidget {
  const HubScreen({super.key});

  void _showMockChallenge(BuildContext context) {
    showIncomingChallenge(
      context,
      challengerName: 'Ciarán',
      challengerAvatarIndex: 2,
      categoryName: 'Movies',
      h2hYou: 5,
      h2hThem: 7,
      onAccept: () => context.go('/countdown'),
      onDecline: () {},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final friends = ref.watch(friendsProvider);
    final matches = ref.watch(matchesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: AppColors.glassPanel,
        onPressed: () => _showMockChallenge(context),
        child: const Icon(Icons.bolt, color: AppColors.amberGlow, size: 18),
      ),
      body: ScreenBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ── Top bar ──────────────────────────────
              Row(
                children: [
                  RapidAvatar(
                    avatarUrl: user.avatarUrl,
                    defaultAvatarIndex: user.defaultAvatarIndex,
                    size: 38,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WELCOME BACK',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '@${user.username}',
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconCircle(
                    size: 38,
                    onTap: () => context.push('/select-opponent'),
                    child: const Icon(Icons.people,
                        color: AppColors.textSecondary, size: 18),
                  ),
                  const SizedBox(width: 8),
                  const _NotificationBell(count: 3),
                ],
              ),
              const SizedBox(height: 24),

              // ── Title ────────────────────────────────
              Text('The Hub', style: AppTypography.serifH(fontSize: 36)),
              const SizedBox(height: 4),
              Text(
                'Ready for another round?',
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // ── CTA ──────────────────────────────────
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClayButton(
                    label: 'Challenge a Friend  \u25B6',
                    isFullWidth: true,
                    onPressed: () => context.push('/select-opponent'),
                  ),
                  const Positioned(
                    top: -6,
                    left: 16,
                    child: Pill(
                      label: '\u25CF LIVE NOW',
                      variant: PillVariant.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Stats row ────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: PubRatingCard(
                      rating: user.rating,
                      weeklyDelta: 12,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GlassCard(
                      child: Column(
                        children: [
                          const DataLabel('Best Category'),
                          const SizedBox(height: 6),
                          SvgPicture.asset(
                            'assets/icons/categories/movies.svg',
                            width: 28,
                            height: 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Movies',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '82% accuracy',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 9,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Social Pulse ─────────────────────────
              _SectionHeader(
                label: 'Social Pulse',
                onViewAll: () {},
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: friends.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    if (index == friends.length) {
                      // "+" button at end
                      return Column(
                        children: [
                          IconCircle(
                            size: 46,
                            onTap: () => context.push('/add-friend'),
                            child: Text(
                              '+',
                              style: GoogleFonts.bricolageGrotesque(
                                fontSize: 18,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    final friend = friends[index];
                    final isOnline = friend.status == 'online';
                    final isOffline = friend.status == 'offline';
                    return Opacity(
                      opacity: isOffline ? 0.4 : 1.0,
                      child: Column(
                        children: [
                          RapidAvatar(
                            avatarUrl: friend.avatarUrl,
                            defaultAvatarIndex: friend.defaultAvatarIndex,
                            size: 46,
                            showOnlineDot: true,
                            isOnline: isOnline,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            friend.username.length > 8
                                ? '${friend.username.substring(0, 8)}…'
                                : friend.username,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 9,
                              color: isOffline
                                  ? AppColors.textTertiary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // ── Recent Matches ───────────────────────
              _SectionHeader(
                label: 'Recent Matches',
                onViewAll: () {},
              ),
              const SizedBox(height: 10),
              ...matches.map((match) {
                final isWin = match.result == 'win';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isWin ? AppColors.greenDim : AppColors.glassPanel,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isWin
                            ? const Color.fromRGBO(0, 246, 101, 0.1)
                            : AppColors.glassStroke,
                      ),
                    ),
                    child: Row(
                      children: [
                        RapidAvatar(
                          avatarUrl: match.opponentAvatarUrl,
                          defaultAvatarIndex:
                              match.opponentDefaultAvatarIndex,
                          size: 34,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'vs @${match.opponentName.toLowerCase()}',
                                style: GoogleFonts.bricolageGrotesque(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${match.categoryName} \u00B7 ${isWin ? "Won" : "Lost"} \u00B7 ${_timeAgo(match.playedAt)}',
                                style: GoogleFonts.bricolageGrotesque(
                                  fontSize: 10,
                                  color: isWin
                                      ? AppColors.signalGreen
                                      : AppColors.blazeOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${match.yourScore ~/ 1000}-${match.theirScore ~/ 1000}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconCircle(
                          size: 30,
                          onTap: () => context.push('/select-opponent'),
                          child: Text(
                            '\u21BA',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              const HomeIndicator(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      ),
    );
  }

  static String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const IconCircle(
          size: 38,
          child:
              Icon(Icons.notifications, color: AppColors.textSecondary, size: 18),
        ),
        if (count > 0)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.blazeOrange,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bgDeep, width: 2),
              ),
              child: Center(
                child: Text(
                  count.toString(),
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.onViewAll});
  final String label;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DataLabel(label),
        const Spacer(),
        GestureDetector(
          onTap: onViewAll,
          child: Text(
            'View All',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              color: AppColors.amberGlow,
            ),
          ),
        ),
      ],
    );
  }
}
