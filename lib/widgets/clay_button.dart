import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

enum _ClayVariant { primary, secondary, danger }

class ClayButton extends StatefulWidget {
  const ClayButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isFullWidth;

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton> {
  bool _pressing = false;

  @override
  Widget build(BuildContext context) {
    return _ClayButtonBase(
      label: widget.label,
      onPressed: widget.onPressed,
      icon: widget.icon,
      isFullWidth: widget.isFullWidth,
      variant: _ClayVariant.primary,
      pressing: _pressing,
      onPressChange: (v) => setState(() => _pressing = v),
    );
  }
}

class ClayButtonSecondary extends StatefulWidget {
  const ClayButtonSecondary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isFullWidth;

  @override
  State<ClayButtonSecondary> createState() => _ClayButtonSecondaryState();
}

class _ClayButtonSecondaryState extends State<ClayButtonSecondary> {
  bool _pressing = false;

  @override
  Widget build(BuildContext context) {
    return _ClayButtonBase(
      label: widget.label,
      onPressed: widget.onPressed,
      icon: widget.icon,
      isFullWidth: widget.isFullWidth,
      variant: _ClayVariant.secondary,
      pressing: _pressing,
      onPressChange: (v) => setState(() => _pressing = v),
    );
  }
}

class ClayButtonDanger extends StatefulWidget {
  const ClayButtonDanger({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isFullWidth;

  @override
  State<ClayButtonDanger> createState() => _ClayButtonDangerState();
}

class _ClayButtonDangerState extends State<ClayButtonDanger> {
  bool _pressing = false;

  @override
  Widget build(BuildContext context) {
    return _ClayButtonBase(
      label: widget.label,
      onPressed: widget.onPressed,
      icon: widget.icon,
      isFullWidth: widget.isFullWidth,
      variant: _ClayVariant.danger,
      pressing: _pressing,
      onPressChange: (v) => setState(() => _pressing = v),
    );
  }
}

class _ClayButtonBase extends StatelessWidget {
  const _ClayButtonBase({
    required this.label,
    required this.onPressed,
    required this.icon,
    required this.isFullWidth,
    required this.variant,
    required this.pressing,
    required this.onPressChange,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isFullWidth;
  final _ClayVariant variant;
  final bool pressing;
  final ValueChanged<bool> onPressChange;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    Color bg;
    Color textColor;
    List<BoxShadow> shadows;
    Border? border;

    switch (variant) {
      case _ClayVariant.primary:
        bg = AppColors.amberGlow; // fallback, gradient used below
        textColor = const Color(0xFFFFF5E8); // warm white
        shadows = [
          const BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 12,
            color: Color(0x60B45309),
          ),
          BoxShadow(
            offset: const Offset(0, 8),
            blurRadius: 24,
            color: AppColors.amberGlow.withValues(alpha: 0.15),
          ),
        ];
        border = null;
      case _ClayVariant.secondary:
        bg = const Color.fromRGBO(255, 255, 255, 0.05);
        textColor = AppColors.textPrimary;
        shadows = [
          const BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 8,
            color: Color.fromRGBO(0, 0, 0, 0.3),
          ),
        ];
        border = Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.12),
        );
      case _ClayVariant.danger:
        bg = AppColors.blazeOrange;
        textColor = Colors.white;
        shadows = [
          const BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 12,
            color: Color(0x607C2D12),
          ),
        ];
        border = null;
    }

    final child = AnimatedScale(
      scale: pressing ? 0.96 : 1.0,
      duration: Duration(milliseconds: pressing ? 80 : 200),
      curve: pressing ? Curves.easeOut : Curves.easeOutBack,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        decoration: BoxDecoration(
          gradient: variant == _ClayVariant.primary
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: enabled
                      ? const [
                          Color(0xFFDEA04A), // warm amber
                          Color(0xFFCC7E35), // amber-orange
                          Color(0xFFB56828), // deeper amber
                        ]
                      : const [
                          Color(0xFF6B5030), // muted amber
                          Color(0xFF5A4028), // muted mid
                          Color(0xFF4A3420), // muted dark
                        ],
                )
              : (variant == _ClayVariant.danger && enabled
                  ? const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFF67020), // bright orange
                        Color(0xFFE05510), // deeper orange
                      ],
                    )
                  : null),
          color: variant == _ClayVariant.primary || (variant == _ClayVariant.danger && enabled)
              ? null
              : (enabled ? bg : bg.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(18),
          border: border,
          boxShadow: enabled ? shadows : [],
        ),
        child: Row(
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 10),
            ],
            Text(
              label.toUpperCase(),
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: enabled ? textColor : textColor.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTapDown: enabled
          ? (_) {
              onPressChange(true);
              HapticFeedback.lightImpact();
            }
          : null,
      onTapUp: enabled
          ? (_) {
              onPressChange(false);
              onPressed!();
            }
          : null,
      onTapCancel: enabled ? () => onPressChange(false) : null,
      child: child,
    );
  }
}
