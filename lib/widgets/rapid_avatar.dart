import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

class RapidAvatar extends StatelessWidget {
  const RapidAvatar({
    super.key,
    this.avatarUrl,
    this.defaultAvatarIndex = 1,
    this.size = 42,
    this.showOnlineDot = false,
    this.isOnline,
  });

  final String? avatarUrl;
  final int defaultAvatarIndex;
  final double size;
  final bool showOnlineDot;
  final bool? isOnline;

  @override
  Widget build(BuildContext context) {
    final hasUrl = avatarUrl != null && avatarUrl!.isNotEmpty;
    final index = defaultAvatarIndex.clamp(1, 12);
    final paddedIndex = index.toString().padLeft(2, '0');

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1A1A22),
              border: Border.all(
                color: AppColors.glassStrokeLight,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: hasUrl
                  ? Image.network(
                      avatarUrl!,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => SvgPicture.asset(
                        'assets/avatars/avatar_$paddedIndex.svg',
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/avatars/avatar_$paddedIndex.svg',
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          if (showOnlineDot && isOnline != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isOnline!
                      ? AppColors.signalGreen
                      : const Color.fromRGBO(255, 255, 255, 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.bgDeep,
                    width: 2.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
