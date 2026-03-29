import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/data_label.dart';
import '../../../widgets/friend_tile.dart';
import '../../../widgets/pill_widget.dart';
import '../../../widgets/rapid_avatar.dart';

/// Friend tile in all status variants
class FriendListStory extends StatelessWidget {
  const FriendListStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataLabel('Online — can challenge'),
          SizedBox(height: 12),
          FriendTile(
            avatar: RapidAvatar(
              defaultAvatarIndex: 2,
              size: 42,
              showOnlineDot: true,
              isOnline: true,
            ),
            name: 'Sarah Connor',
            username: '@sconnor',
            status: FriendStatus.online,
            subtitle: '\u25CF Online \u00B7 24ms',
          ),
          SizedBox(height: 16),
          DataLabel('In match — busy'),
          SizedBox(height: 12),
          FriendTile(
            avatar: RapidAvatar(
              defaultAvatarIndex: 7,
              size: 42,
              showOnlineDot: true,
              isOnline: true,
            ),
            name: 'Aisha Martinez',
            username: '@aisha_m',
            status: FriendStatus.inMatch,
            subtitle: '\u25CF In a Match',
            trailing: Pill(label: 'Busy', variant: PillVariant.glass),
          ),
          SizedBox(height: 16),
          DataLabel('Offline'),
          SizedBox(height: 12),
          FriendTile(
            avatar: RapidAvatar(
              defaultAvatarIndex: 3,
              size: 42,
              showOnlineDot: true,
              isOnline: false,
            ),
            name: 'Tom Brady',
            username: '@tommy_b',
            status: FriendStatus.offline,
            subtitle: 'Last seen 2h ago',
          ),
          SizedBox(height: 16),
          DataLabel('Won match — green accent'),
          SizedBox(height: 12),
          FriendTile(
            avatar: RapidAvatar(defaultAvatarIndex: 9, size: 42),
            name: 'Marcus Chen',
            username: '@marc_nyc',
            backgroundColor: AppColors.greenDim,
            borderColor: Color.fromRGBO(0, 246, 101, 0.2),
            trailing: Pill(label: 'Won', variant: PillVariant.green),
          ),
          SizedBox(height: 16),
          DataLabel('Lost match — default'),
          SizedBox(height: 12),
          FriendTile(
            avatar: RapidAvatar(defaultAvatarIndex: 11, size: 42),
            name: 'Niamh Dunne',
            username: '@niamh_d',
            trailing: Pill(label: 'Lost', variant: PillVariant.glass),
          ),
        ],
      ),
    );
  }
}
