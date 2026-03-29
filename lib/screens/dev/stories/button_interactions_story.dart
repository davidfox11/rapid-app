import 'package:flutter/material.dart';

import '../../../widgets/clay_button.dart';
import '../../../widgets/data_label.dart';

/// Interactive button variants — tap to feel spring physics + haptics
class ButtonInteractionsStory extends StatelessWidget {
  const ButtonInteractionsStory({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DataLabel('Primary — tap for spring bounce + haptic'),
          const SizedBox(height: 12),
          ClayButton(
            label: 'Challenge a Friend',
            isFullWidth: true,
            onPressed: () {},
          ),
          const SizedBox(height: 20),
          const DataLabel('Primary with icon'),
          const SizedBox(height: 12),
          ClayButton(
            label: 'Lock It In',
            icon: const Icon(Icons.lock, color: Color(0xFFFFF5E8), size: 16),
            isFullWidth: true,
            onPressed: () {},
          ),
          const SizedBox(height: 20),
          const DataLabel('Secondary — glass effect'),
          const SizedBox(height: 12),
          ClayButtonSecondary(
            label: 'Invite Link',
            isFullWidth: true,
            onPressed: () {},
          ),
          const SizedBox(height: 20),
          const DataLabel('Danger'),
          const SizedBox(height: 12),
          ClayButtonDanger(
            label: 'Cancel Match',
            isFullWidth: true,
            onPressed: () {},
          ),
          const SizedBox(height: 20),
          const DataLabel('Disabled'),
          const SizedBox(height: 12),
          const ClayButton(
            label: 'Continue',
            isFullWidth: true,
          ),
          const SizedBox(height: 20),
          const DataLabel('Side by side'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClayButtonSecondary(
                  label: 'Decline',
                  isFullWidth: true,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClayButton(
                  label: 'Accept',
                  isFullWidth: true,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
