import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/clay_button.dart';
import '../../widgets/data_label.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/home_indicator.dart';
import '../../widgets/icon_circle.dart';
import '../../widgets/pill_widget.dart';
import '../../widgets/rapid_avatar.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/search_bar_widget.dart';

// Mock search results
class _SearchResult {
  const _SearchResult({
    required this.name,
    required this.username,
    required this.avatarIndex,
    required this.status, // "friend", "pending", "none"
  });
  final String name;
  final String username;
  final int avatarIndex;
  final String status;
}

const _mockResults = [
  _SearchResult(
      name: 'Sarah',
      username: 'sarah_oz',
      avatarIndex: 6,
      status: 'friend'),
  _SearchResult(
      name: 'SarahKnows',
      username: 'sarahknows',
      avatarIndex: 12,
      status: 'pending'),
  _SearchResult(
      name: 'Sarah_M',
      username: 'sarah_m_quiz',
      avatarIndex: 5,
      status: 'none'),
];

class AddFriendScreen extends ConsumerStatefulWidget {
  const AddFriendScreen({super.key});

  @override
  ConsumerState<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends ConsumerState<AddFriendScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _copied = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_SearchResult> get _filteredResults {
    if (_query.isEmpty) return [];
    return _mockResults
        .where((r) =>
            r.name.toLowerCase().contains(_query.toLowerCase()) ||
            r.username.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  Future<void> _copyUsername() async {
    final user = ref.read(currentUserProvider);
    await Clipboard.setData(ClipboardData(text: '@${user.username}'));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final results = _filteredResults;

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

                      // Header
                      Row(
                        children: [
                          IconCircle(
                            size: 36,
                            onTap: () => context.pop(),
                            child: const Icon(Icons.arrow_back,
                                color: AppColors.textSecondary, size: 16),
                          ),
                          const SizedBox(width: 12),
                          Text('Add Friend',
                              style: AppTypography.serifH(fontSize: 24)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Search
                      RapidSearchBar(
                        hintText: 'Search by username...',
                        controller: _searchController,
                        onChanged: (v) => setState(() => _query = v.trim()),
                      ),
                      const SizedBox(height: 24),

                      // Results
                      if (_query.isNotEmpty) ...[
                        const DataLabel('Results'),
                        const SizedBox(height: 10),
                        if (results.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                'No results found',
                                style: GoogleFonts.bricolageGrotesque(
                                  fontSize: 13,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ),
                          )
                        else
                          ...results.map((r) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _ResultTile(result: r),
                              )),
                      ],

                      // Divider
                      Container(
                        height: 1,
                        color: AppColors.glassStroke,
                        margin: const EdgeInsets.symmetric(vertical: 24),
                      ),

                      // Share section
                      const DataLabel('Share Your Username'),
                      const SizedBox(height: 12),
                      GlassCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '@${user.username}',
                                    style: GoogleFonts.bricolageGrotesque(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _copied ? 'Copied!' : 'Tap to copy',
                                    style: GoogleFonts.bricolageGrotesque(
                                      fontSize: 11,
                                      color: _copied
                                          ? AppColors.signalGreen
                                          : AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconCircle(
                              size: 36,
                              onTap: _copyUsername,
                              child: const Icon(Icons.copy,
                                  color: AppColors.textSecondary, size: 14),
                            ),
                            const SizedBox(width: 8),
                            const IconCircle(
                              size: 36,
                              child: Icon(Icons.share,
                                  color: AppColors.textSecondary, size: 14),
                            ),
                          ],
                        ),
                      ),
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

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.result});
  final _SearchResult result;

  @override
  Widget build(BuildContext context) {
    Widget trailing;
    switch (result.status) {
      case 'friend':
        trailing = const Pill(label: 'Friends \u2713', variant: PillVariant.green);
      case 'pending':
        trailing = const Pill(label: 'Pending', variant: PillVariant.amber);
      default:
        trailing = ClayButtonSecondary(
          label: 'Add',
          onPressed: () {},
        );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.glassPanel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassStroke),
      ),
      child: Row(
        children: [
          RapidAvatar(
            defaultAvatarIndex: result.avatarIndex,
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.name,
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '@${result.username}',
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
