import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../providers/categories_provider.dart';
import '../../providers/game_setup_provider.dart';
import '../../widgets/category_card.dart';
import '../../widgets/clay_button.dart';
import '../../widgets/home_indicator.dart';
import '../../widgets/icon_circle.dart';
import '../../widgets/pill_widget.dart';
import '../../widgets/rapid_avatar.dart';
import '../../widgets/screen_background.dart';

class CategorySelectScreen extends ConsumerStatefulWidget {
  const CategorySelectScreen({super.key});

  @override
  ConsumerState<CategorySelectScreen> createState() =>
      _CategorySelectScreenState();
}

class _CategorySelectScreenState extends ConsumerState<CategorySelectScreen> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final opponent = ref.watch(selectedOpponentProvider);

    return ScreenBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Top bar
              Row(
                children: [
                  IconCircle(
                    size: 36,
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back,
                        color: AppColors.textSecondary, size: 16),
                  ),
                  const Spacer(),
                  if (opponent != null) ...[
                    RapidAvatar(
                      avatarUrl: opponent.avatarUrl,
                      defaultAvatarIndex: opponent.defaultAvatarIndex,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'vs ${opponent.displayName}',
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Pill(
                      label: '\u25CF Ready',
                      variant: PillVariant.green,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Choose your\nVessel.',
                style: AppTypography.serifH(fontSize: 36),
              ),
              const SizedBox(height: 6),
              Text(
                'Pick a category to battle in.',
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),

              // Categories
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...List.generate(categories.length, (i) {
                        final cat = categories[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: CategoryCard(
                            iconPath: cat.iconPath,
                            name: cat.name,
                            description: cat.description,
                            questionCount: cat.questionCount,
                            isSelected: _selectedIndex == i,
                            onTap: () => setState(() => _selectedIndex = i),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // CTA
              ClayButton(
                label: 'Lock It In',
                isFullWidth: true,
                onPressed: _selectedIndex != null
                    ? () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            categories[_selectedIndex!];
                        context.push('/waiting-lobby');
                      }
                    : null,
              ),
              const SizedBox(height: 16),
              const HomeIndicator(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
