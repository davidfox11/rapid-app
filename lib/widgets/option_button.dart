import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

enum OptionState { default_, selected, correct, wrong, dimmed }

class OptionButton extends StatefulWidget {
  const OptionButton({
    super.key,
    required this.letter,
    required this.text,
    this.state = OptionState.default_,
    this.onTap,
    this.playerAvatar,
    this.opponentAvatar,
  });

  final String letter;
  final String text;
  final OptionState state;
  final VoidCallback? onTap;
  final Widget? playerAvatar;
  final Widget? opponentAvatar;

  @override
  State<OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton> {
  bool _pressing = false;

  @override
  Widget build(BuildContext context) {
    final isDefault = widget.state == OptionState.default_;
    final tappable = isDefault && widget.onTap != null;

    Color bgColor;
    Color borderColor;
    Color letterBg;
    Color letterColor;
    double borderWidth;

    switch (widget.state) {
      case OptionState.default_:
        bgColor = AppColors.glassPanel;
        borderColor = AppColors.glassStroke;
        letterBg = Colors.transparent;
        letterColor = AppColors.textSecondary;
        borderWidth = 1.5;
      case OptionState.selected:
        bgColor = AppColors.amberDim;
        borderColor = AppColors.amberGlow;
        letterBg = AppColors.amberGlow;
        letterColor = Colors.black;
        borderWidth = 1.5;
      case OptionState.correct:
        bgColor = AppColors.greenDim;
        borderColor = AppColors.signalGreen;
        letterBg = AppColors.signalGreen;
        letterColor = Colors.black;
        borderWidth = 1.5;
      case OptionState.wrong:
        bgColor = AppColors.orangeDim;
        borderColor = AppColors.blazeOrange;
        letterBg = AppColors.blazeOrange;
        letterColor = Colors.white;
        borderWidth = 1.5;
      case OptionState.dimmed:
        bgColor = AppColors.glassPanel;
        borderColor = AppColors.glassStroke;
        letterBg = Colors.transparent;
        letterColor = AppColors.textSecondary;
        borderWidth = 1.5;
    }

    final content = AnimatedScale(
      scale: _pressing ? 0.96 : 1.0,
      duration: Duration(milliseconds: _pressing ? 80 : 200),
      curve: _pressing ? Curves.easeOut : Curves.easeOutBack,
      child: Opacity(
        opacity: widget.state == OptionState.dimmed ? 0.3 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: Row(
            children: [
              // Letter badge
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: letterBg,
                  borderRadius: BorderRadius.circular(8),
                  border: letterBg == Colors.transparent
                      ? Border.all(color: AppColors.glassStroke)
                      : null,
                ),
                child: Center(
                  child: Text(
                    widget.letter,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: letterColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Answer text
              Expanded(
                child: Text(
                  widget.text,
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              // Avatars during reveal
              if (widget.playerAvatar != null || widget.opponentAvatar != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.playerAvatar != null) ...[
                      const SizedBox(width: 8),
                      widget.playerAvatar!,
                    ],
                    if (widget.opponentAvatar != null) ...[
                      const SizedBox(width: 4),
                      widget.opponentAvatar!,
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );

    return GestureDetector(
      onTapDown: tappable
          ? (_) {
              setState(() => _pressing = true);
              HapticFeedback.lightImpact();
            }
          : null,
      onTapUp: tappable
          ? (_) {
              setState(() => _pressing = false);
              widget.onTap!();
            }
          : null,
      onTapCancel: tappable ? () => setState(() => _pressing = false) : null,
      child: content,
    );
  }
}
