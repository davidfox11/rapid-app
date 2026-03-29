import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/screen_background.dart';

class AssetTestScreen extends StatelessWidget {
  const AssetTestScreen({super.key});

  static const _categories = [
    ('general_knowledge', 'General Knowledge'),
    ('movies', 'Movies'),
    ('history', 'History'),
    ('geography', 'Geography'),
    ('ireland', 'Ireland'),
  ];

  static const _avatarNames = [
    '01 Amber Beacon',
    '02 Emerald Shift',
    '03 Blaze Ring',
    '04 Plum Stacks',
    '05 Gold Diamond',
    '06 Teal Waves',
    '07 Rose Hex',
    '08 Amber Split',
    '09 Midnight Bars',
    '10 Solar Flare',
    '11 Mint Arch',
    '12 Copper Cross',
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Asset Test', style: AppTypography.serifH(fontSize: 32)),
              const SizedBox(height: 32),

              // Category Icons section
              Text(
                'CATEGORY ICONS',
                style: AppTypography.dataLabel,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _categories.map((cat) {
                  return Column(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/categories/${cat.$1}.svg',
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 60,
                        child: Text(
                          cat.$2,
                          style: AppTypography.body(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 48),

              // Avatars section
              Text(
                'DEFAULT AVATARS',
                style: AppTypography.dataLabel,
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final num = (index + 1).toString().padLeft(2, '0');
                  return Column(
                    children: [
                      SvgPicture.asset(
                        'assets/avatars/avatar_$num.svg',
                        width: 64,
                        height: 64,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _avatarNames[index],
                        style: AppTypography.body(
                          fontSize: 9,
                          color: AppColors.textTertiary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
