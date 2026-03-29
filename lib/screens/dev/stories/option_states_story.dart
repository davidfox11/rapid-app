import 'package:flutter/material.dart';

import '../../../widgets/option_button.dart';

/// All 5 option button states, interactive
class OptionStatesStory extends StatelessWidget {
  const OptionStatesStory({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          OptionButton(
            letter: 'A',
            text: 'Default — tap me for press animation',
            state: OptionState.default_,
            onTap: () {},
          ),
          const SizedBox(height: 10),
          const OptionButton(
            letter: 'B',
            text: 'Selected (player picked this)',
            state: OptionState.selected,
          ),
          const SizedBox(height: 10),
          const OptionButton(
            letter: 'C',
            text: 'Correct answer (green)',
            state: OptionState.correct,
          ),
          const SizedBox(height: 10),
          const OptionButton(
            letter: 'D',
            text: 'Wrong answer (orange)',
            state: OptionState.wrong,
          ),
          const SizedBox(height: 10),
          const OptionButton(
            letter: 'A',
            text: 'Dimmed (not chosen)',
            state: OptionState.dimmed,
          ),
        ],
      ),
    );
  }
}
