import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/clay_button.dart';
import '../../widgets/data_label.dart';
import '../../widgets/home_indicator.dart';
import '../../widgets/icon_circle.dart';
import '../../widgets/screen_background.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  Timer? _debounce;

  late final int _avatarIndex;
  String? _usernameError;
  bool _usernameValid = false;
  bool _usernameChecking = false;

  @override
  void initState() {
    super.initState();
    _avatarIndex = Random().nextInt(12) + 1;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  bool get _canContinue =>
      _displayNameController.text.trim().isNotEmpty &&
      _usernameValid &&
      !_usernameChecking;

  void _onUsernameChanged(String value) {
    _debounce?.cancel();
    setState(() {
      _usernameChecking = true;
      _usernameError = null;
      _usernameValid = false;
    });

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _validateUsername(value.trim());
    });
  }

  void _validateUsername(String value) {
    if (value.length < 3) {
      setState(() {
        _usernameChecking = false;
        _usernameError = 'Must be at least 3 characters';
        _usernameValid = false;
      });
      return;
    }
    if (value == 'taken') {
      setState(() {
        _usernameChecking = false;
        _usernameError = 'Username is already taken';
        _usernameValid = false;
      });
      return;
    }
    setState(() {
      _usernameChecking = false;
      _usernameError = null;
      _usernameValid = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final paddedIndex = _avatarIndex.toString().padLeft(2, '0');

    return ScreenBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Back button
                      IconCircle(
                        size: 36,
                        onTap: () => context.pop(),
                        child: const Icon(Icons.arrow_back,
                            color: AppColors.textSecondary, size: 16),
                      ),
                      const SizedBox(height: 32),

                      // Title
                      Text(
                        'Welcome to\nthe Table.',
                        style: AppTypography.serifH(fontSize: 32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Let's set up your profile. This is how others will see you.",
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Avatar
                      Center(
                        child: Column(
                          children: [
                            CustomPaint(
                              painter: _DashedCirclePainter(),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  color: AppColors.glassPanel,
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: SvgPicture.asset(
                                    'assets/avatars/avatar_$paddedIndex.svg',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Tap to add a photo (or keep the default)',
                              style: GoogleFonts.bricolageGrotesque(
                                fontSize: 11,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Display Name field
                      const DataLabel('Display Name'),
                      const SizedBox(height: 8),
                      _InputField(
                        controller: _displayNameController,
                        hintText: 'How others will see you',
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 24),

                      // Username field
                      const DataLabel('Username'),
                      const SizedBox(height: 8),
                      _InputField(
                        controller: _usernameController,
                        hintText: 'your_username',
                        prefix: '@',
                        onChanged: _onUsernameChanged,
                        suffix: _usernameChecking
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.textSecondary,
                                ),
                              )
                            : _usernameValid
                                ? const Icon(Icons.check,
                                    color: AppColors.signalGreen, size: 16)
                                : _usernameError != null
                                    ? const Icon(Icons.close,
                                        color: AppColors.errorRed, size: 16)
                                    : null,
                      ),
                      if (_usernameValid)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'Username is available',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              color: AppColors.signalGreen,
                            ),
                          ),
                        ),
                      if (_usernameError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _usernameError!,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              color: AppColors.errorRed,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Continue button (pinned at bottom)
              ClayButton(
                label: 'Continue \u2192',
                isFullWidth: true,
                onPressed: _canContinue ? () => context.go('/home') : null,
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

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hintText,
    this.prefix,
    this.suffix,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final String? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 0.03),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.glassStroke),
        ),
        child: Row(
          children: [
            if (prefix != null)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  prefix!,
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 15,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: GoogleFonts.bricolageGrotesque(
                    fontSize: 15,
                    color: AppColors.textTertiary,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (suffix != null) ...[
              const SizedBox(width: 8),
              suffix!,
            ],
          ],
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.glassStrokeLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const dashLength = 6.0;
    const gapLength = 4.0;
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    final circumference = 2 * pi * radius;
    final dashCount = (circumference / (dashLength + gapLength)).floor();

    for (int i = 0; i < dashCount; i++) {
      final startAngle =
          (i * (dashLength + gapLength) / circumference) * 2 * pi;
      final sweepAngle = (dashLength / circumference) * 2 * pi;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle - pi / 2,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
