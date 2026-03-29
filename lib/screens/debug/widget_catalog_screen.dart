import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/category_card.dart';
import '../../widgets/clay_button.dart';
import '../../widgets/data_label.dart';
import '../../widgets/friend_tile.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/home_indicator.dart';
import '../../widgets/icon_circle.dart';
import '../../widgets/option_button.dart';
import '../../widgets/pill_widget.dart';
import '../../widgets/pub_rating_card.dart';
import '../../widgets/rapid_avatar.dart';
import '../../widgets/round_dots.dart';
import '../../widgets/round_result_card.dart';
import '../../widgets/score_bar.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/timer_ring.dart';

class WidgetCatalogScreen extends StatefulWidget {
  const WidgetCatalogScreen({super.key});

  @override
  State<WidgetCatalogScreen> createState() => _WidgetCatalogScreenState();
}

class _WidgetCatalogScreenState extends State<WidgetCatalogScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Widget Catalog',
                  style: AppTypography.serifH(fontSize: 28)),
              const SizedBox(height: 32),

              // === PRIMITIVE WIDGETS ===

              // GlassCard
              const DataLabel('Glass Card'),
              const SizedBox(height: 12),
              GlassCard(
                child: Text('GlassCard — blur 20, radius 16',
                    style: AppTypography.bodyMedium),
              ),
              const SizedBox(height: 12),
              GlassCardSmall(
                child: Text('GlassCardSmall — blur 16, radius 12',
                    style: AppTypography.bodySmall),
              ),
              const SizedBox(height: 32),

              // ClayButtons
              const DataLabel('Clay Buttons'),
              const SizedBox(height: 12),
              ClayButton(
                  label: 'Primary', onPressed: () {}, isFullWidth: true),
              const SizedBox(height: 12),
              ClayButtonSecondary(
                  label: 'Secondary', onPressed: () {}, isFullWidth: true),
              const SizedBox(height: 12),
              ClayButtonDanger(
                  label: 'Danger', onPressed: () {}, isFullWidth: true),
              const SizedBox(height: 12),
              ClayButton(
                label: 'With Icon',
                icon: const Icon(Icons.bolt, color: Colors.black, size: 18),
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              const ClayButton(label: 'Disabled'),
              const SizedBox(height: 32),

              // Pills
              const DataLabel('Pills'),
              const SizedBox(height: 12),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Pill(label: 'Online', variant: PillVariant.green),
                  Pill(label: '1,247 ELO', variant: PillVariant.amber),
                  Pill(label: 'Round 3/10', variant: PillVariant.glass),
                ],
              ),
              const SizedBox(height: 32),

              // IconCircle
              const DataLabel('Icon Circle'),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconCircle(
                    onTap: () {},
                    child: const Icon(Icons.settings,
                        color: AppColors.textSecondary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  const IconCircle(
                    child:
                        Icon(Icons.person, color: AppColors.textSecondary, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // === COMPLEX WIDGETS ===

              // RapidAvatar
              const DataLabel('Rapid Avatar'),
              const SizedBox(height: 12),
              const Row(
                children: [
                  RapidAvatar(
                      defaultAvatarIndex: 1,
                      size: 48,
                      showOnlineDot: true,
                      isOnline: true),
                  SizedBox(width: 12),
                  RapidAvatar(
                      defaultAvatarIndex: 5,
                      size: 42,
                      showOnlineDot: true,
                      isOnline: false),
                  SizedBox(width: 12),
                  RapidAvatar(defaultAvatarIndex: 8, size: 36),
                  SizedBox(width: 12),
                  RapidAvatar(defaultAvatarIndex: 12, size: 28),
                  SizedBox(width: 12),
                  RapidAvatar(
                    avatarUrl: 'https://i.pravatar.cc/100',
                    size: 48,
                    showOnlineDot: true,
                    isOnline: true,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // OptionButton — all states
              const DataLabel('Option Button'),
              const SizedBox(height: 12),
              OptionButton(
                  letter: 'A',
                  text: 'Default state',
                  state: OptionState.default_,
                  onTap: () {}),
              const SizedBox(height: 8),
              const OptionButton(
                  letter: 'B',
                  text: 'Selected state',
                  state: OptionState.selected),
              const SizedBox(height: 8),
              const OptionButton(
                letter: 'C',
                text: 'Correct answer',
                state: OptionState.correct,
                playerAvatar: RapidAvatar(
                    defaultAvatarIndex: 1, size: 22),
              ),
              const SizedBox(height: 8),
              const OptionButton(
                letter: 'D',
                text: 'Wrong answer',
                state: OptionState.wrong,
                opponentAvatar: RapidAvatar(
                    defaultAvatarIndex: 3, size: 22),
              ),
              const SizedBox(height: 8),
              const OptionButton(
                  letter: 'A',
                  text: 'Dimmed state',
                  state: OptionState.dimmed),
              const SizedBox(height: 32),

              // RoundDots
              const DataLabel('Round Dots'),
              const SizedBox(height: 12),
              const RoundDots(currentRound: 4, totalRounds: 10),
              const SizedBox(height: 32),

              // TimerRing
              const DataLabel('Timer Ring'),
              const SizedBox(height: 12),
              const Row(
                children: [
                  TimerRing(totalSeconds: 15, remainingSeconds: 8),
                  SizedBox(width: 24),
                  TimerRing(totalSeconds: 15, remainingSeconds: 3),
                  SizedBox(width: 24),
                  TimerRing(totalSeconds: 15, remainingSeconds: 15, size: 56),
                ],
              ),
              const SizedBox(height: 32),

              // ScoreBar
              const DataLabel('Score Bar'),
              const SizedBox(height: 12),
              const ScoreBar(
                playerAvatar:
                    RapidAvatar(defaultAvatarIndex: 1, size: 26),
                playerScore: 2450,
                opponentAvatar:
                    RapidAvatar(defaultAvatarIndex: 7, size: 26),
                opponentScore: 1800,
                categoryLabel: 'General Knowledge',
              ),
              const SizedBox(height: 32),

              // FriendTile
              const DataLabel('Friend Tile'),
              const SizedBox(height: 12),
              FriendTile(
                avatar: const RapidAvatar(
                    defaultAvatarIndex: 2,
                    size: 42,
                    showOnlineDot: true,
                    isOnline: true),
                name: 'Sarah Connor',
                username: '@sconnor',
                status: FriendStatus.online,
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.amberDim,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color.fromRGBO(255, 191, 94, 0.25)),
                  ),
                  child: Text('Challenge',
                      style: AppTypography.body(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.amberGlow)),
                ),
              ),
              const SizedBox(height: 8),
              const FriendTile(
                avatar: RapidAvatar(
                    defaultAvatarIndex: 9,
                    size: 42,
                    showOnlineDot: true,
                    isOnline: false),
                name: 'John Doe',
                username: '@jdoe',
                status: FriendStatus.offline,
                subtitle: 'Last seen 2h ago',
              ),
              const SizedBox(height: 8),
              const FriendTile(
                avatar: RapidAvatar(
                    defaultAvatarIndex: 4, size: 42),
                name: 'Won Match',
                username: '@winner',
                backgroundColor: AppColors.greenDim,
                borderColor: Color.fromRGBO(0, 246, 101, 0.2),
                trailing: Pill(
                    label: 'Won', variant: PillVariant.green),
              ),
              const SizedBox(height: 32),

              // CategoryCard
              const DataLabel('Category Card'),
              const SizedBox(height: 12),
              CategoryCard(
                iconPath: 'assets/icons/categories/general_knowledge.svg',
                name: 'General Knowledge',
                description: 'A bit of everything',
                questionCount: 500,
                isSelected: true,
                onTap: () {},
              ),
              const SizedBox(height: 8),
              CategoryCard(
                iconPath: 'assets/icons/categories/movies.svg',
                name: 'Movies',
                description: 'Film & cinema',
                questionCount: 320,
                onTap: () {},
              ),
              const SizedBox(height: 32),

              // SearchBar
              const DataLabel('Search Bar'),
              const SizedBox(height: 12),
              RapidSearchBar(
                hintText: 'Search friends...',
                controller: _searchController,
              ),
              const SizedBox(height: 32),

              // RoundResultCard
              const DataLabel('Round Result Card'),
              const SizedBox(height: 12),
              const RoundResultCard(
                roundNumber: 3,
                questionText:
                    'What is the largest ocean on Earth?',
                correctAnswer: 'Pacific Ocean',
                playerResult: '✓ 1.2s',
                opponentResult: '✕ 3.4s',
                playerCorrect: true,
                opponentCorrect: false,
              ),
              const SizedBox(height: 8),
              const RoundResultCard(
                roundNumber: 4,
                questionText: 'Who painted the Mona Lisa?',
                correctAnswer: 'Leonardo da Vinci',
                playerResult: '✕ 5.1s',
                opponentResult: '✓ 2.0s',
                playerCorrect: false,
                opponentCorrect: true,
              ),
              const SizedBox(height: 32),

              // PubRatingCard
              const DataLabel('Pub Rating Card'),
              const SizedBox(height: 12),
              const PubRatingCard(rating: 1247, weeklyDelta: 42),
              const SizedBox(height: 8),
              const PubRatingCard(rating: 980, weeklyDelta: -15),
              const SizedBox(height: 32),

              // DataLabel + HomeIndicator
              const DataLabel('Home Indicator'),
              const SizedBox(height: 12),
              const HomeIndicator(),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
