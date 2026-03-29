import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../models/friend.dart';
import '../../providers/friends_provider.dart';
import '../../providers/game_setup_provider.dart';
import '../../widgets/data_label.dart';
import '../../widgets/home_indicator.dart';
import '../../widgets/icon_circle.dart';
import '../../widgets/pill_widget.dart';
import '../../widgets/rapid_avatar.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/search_bar_widget.dart';

class SelectOpponentScreen extends ConsumerStatefulWidget {
  const SelectOpponentScreen({super.key});

  @override
  ConsumerState<SelectOpponentScreen> createState() =>
      _SelectOpponentScreenState();
}

class _SelectOpponentScreenState extends ConsumerState<SelectOpponentScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static const _statusOrder = {'online': 0, 'in_match': 1, 'offline': 2};

  List<Friend> _sortedAndFiltered(List<Friend> friends) {
    var list = friends.toList()
      ..sort((a, b) =>
          (_statusOrder[a.status] ?? 3).compareTo(_statusOrder[b.status] ?? 3));
    if (_query.isNotEmpty) {
      list = list
          .where((f) =>
              f.displayName.toLowerCase().contains(_query.toLowerCase()) ||
              f.username.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final friends = ref.watch(friendsProvider);
    final sorted = _sortedAndFiltered(friends);

    return ScreenBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconCircle(
                            size: 36,
                            onTap: () => context.pop(),
                            child: const Icon(Icons.arrow_back,
                                color: AppColors.textSecondary, size: 16),
                          ),
                          const SizedBox(width: 12),
                          Text('Select Opponent',
                              style: AppTypography.serifH(fontSize: 24)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      RapidSearchBar(
                        hintText: 'Search friends...',
                        controller: _searchController,
                        onChanged: (v) => setState(() => _query = v.trim()),
                      ),
                      const SizedBox(height: 20),
                      DataLabel('Friends (${sorted.length})'),
                      const SizedBox(height: 10),
                      ...sorted.map((f) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _FriendRow(
                              friend: f,
                              onChallenge: () {
                                ref.read(selectedOpponentProvider.notifier).state = f;
                                context.push('/category-select');
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              const HomeIndicator(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _FriendRow extends StatelessWidget {
  const _FriendRow({required this.friend, required this.onChallenge});
  final Friend friend;
  final VoidCallback onChallenge;

  @override
  Widget build(BuildContext context) {
    final isOnline = friend.status == 'online';
    final isInMatch = friend.status == 'in_match';
    final isOffline = friend.status == 'offline';

    Widget trailing;
    if (isOnline) {
      trailing = _ChallengeButton(onTap: onChallenge);
    } else if (isInMatch) {
      trailing = const Pill(label: 'Busy', variant: PillVariant.glass);
    } else {
      trailing = _ChallengeButton(label: 'Invite', onTap: onChallenge);
    }

    String subtitle;
    Color subtitleColor;
    if (isOnline) {
      subtitle = '\u25CF Online \u00B7 24ms';
      subtitleColor = AppColors.signalGreen;
    } else if (isInMatch) {
      subtitle = '\u25CF In a Match';
      subtitleColor = AppColors.amberGlow;
    } else {
      final ago = friend.lastSeenAt != null
          ? _timeAgo(friend.lastSeenAt!)
          : 'a while ago';
      subtitle = 'Last seen $ago';
      subtitleColor = AppColors.textSecondary;
    }

    return Opacity(
      opacity: isOffline ? 0.6 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.glassPanel,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.glassStroke),
        ),
        child: Row(
          children: [
            RapidAvatar(
              avatarUrl: friend.avatarUrl,
              defaultAvatarIndex: friend.defaultAvatarIndex,
              size: 42,
              showOnlineDot: !isOffline,
              isOnline: isOnline || isInMatch,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.displayName,
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 11,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  static String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'yesterday';
    return '${diff.inDays}d ago';
  }
}

class _ChallengeButton extends StatelessWidget {
  const _ChallengeButton({this.label = 'Challenge', required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.amberDim,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color.fromRGBO(255, 191, 94, 0.25),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.amberGlow,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
