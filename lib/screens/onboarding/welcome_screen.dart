import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../widgets/home_indicator.dart';
import '../../widgets/screen_background.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _loading = false;

  Future<void> _signIn() async {
    setState(() => _loading = true);
    // Mock sign-in delay
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _loading = false);
    context.go('/profile-setup');
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            children: [
              const Spacer(),

              // Lightning bolt with glow
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: const Icon(
                  Icons.bolt,
                  size: 56,
                  color: AppColors.amberGlow,
                  shadows: [
                    Shadow(
                      color: Color.fromRGBO(255, 191, 94, 0.3),
                      blurRadius: 30,
                    ),
                  ],
                ),
              ),

              // "Rapid." wordmark
              Text(
                'Rapid.',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 56,
                  color: Colors.white,
                ),
              ),

              // Tagline
              const SizedBox(height: 10),
              Text(
                'THE DIGITAL PUB',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 80),
              const Spacer(),

              // Auth buttons
              _AuthButton(
                label: 'Continue with Apple',
                icon: const Icon(Icons.apple, color: Colors.black, size: 20),
                backgroundColor: Colors.white,
                textColor: Colors.black,
                loading: _loading,
                onTap: _signIn,
              ),
              const SizedBox(height: 12),
              _AuthButton(
                label: 'Continue with Google',
                icon: Text(
                  'G',
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                backgroundColor: AppColors.glassPanel,
                textColor: AppColors.textPrimary,
                border: Border.all(color: AppColors.glassStrokeLight),
                loading: _loading,
                onTap: _signIn,
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

class _AuthButton extends StatelessWidget {
  const _AuthButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.border,
    required this.loading,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final Color backgroundColor;
  final Color textColor;
  final BoxBorder? border;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: border,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            else ...[
              icon,
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
