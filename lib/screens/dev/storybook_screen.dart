import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/screen_background.dart';
import 'stories/option_states_story.dart';
import 'stories/reveal_scenarios_story.dart';
import 'stories/game_summary_story.dart';
import 'stories/button_interactions_story.dart';
import 'stories/timer_states_story.dart';
import 'stories/friend_list_story.dart';

class StorybookScreen extends StatelessWidget {
  const StorybookScreen({super.key});

  static const _stories = <String, Widget>{
    'Answer Reveal Scenarios': RevealScenariosStory(),
    'Option Button States': OptionStatesStory(),
    'Game Summary Variants': GameSummaryStory(),
    'Button Interactions': ButtonInteractionsStory(),
    'Timer States': TimerStatesStory(),
    'Friend List Variants': FriendListStory(),
  };

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: SafeArea(
        child: DefaultTabController(
          length: _stories.length,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Row(
                  children: [
                    Text('Storybook',
                        style: AppTypography.serifH(fontSize: 24)),
                    const Spacer(),
                    Text(
                      '${_stories.length} stories',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: AppColors.amberGlow,
                unselectedLabelColor: AppColors.textTertiary,
                indicatorColor: AppColors.amberGlow,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Colors.transparent,
                labelStyle: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                tabs: _stories.keys
                    .map((name) => Tab(text: name.toUpperCase()))
                    .toList(),
              ),
              Expanded(
                child: TabBarView(
                  children: _stories.values.toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
