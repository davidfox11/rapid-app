import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'clay_button.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Leave',
  String cancelLabel = 'Stay',
  bool isDanger = true,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (_) => _ConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      isDanger: isDanger,
    ),
  );
  return result ?? false;
}

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.isDanger,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        decoration: TextDecoration.none,
        color: AppColors.textPrimary,
      ),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(false),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: const Color.fromRGBO(0, 0, 0, 0.7),
            child: Center(
              child: GestureDetector(
                onTap: () {}, // prevent tap-through
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color.fromRGBO(255, 255, 255, 0.10),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(title, style: AppTypography.serifH(fontSize: 22)),
                        const SizedBox(height: 12),
                        Text(
                          message,
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: ClayButtonSecondary(
                                label: cancelLabel,
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                isFullWidth: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: isDanger
                                  ? ClayButtonDanger(
                                      label: confirmLabel,
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      isFullWidth: true,
                                    )
                                  : ClayButton(
                                      label: confirmLabel,
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      isFullWidth: true,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
