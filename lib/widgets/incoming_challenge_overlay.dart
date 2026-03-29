import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/clay_button.dart';
import '../widgets/pill_widget.dart';
import '../widgets/rapid_avatar.dart';

class IncomingChallengeOverlay extends StatefulWidget {
  const IncomingChallengeOverlay({
    super.key,
    required this.challengerName,
    required this.challengerAvatarIndex,
    required this.categoryName,
    required this.h2hYou,
    required this.h2hThem,
    required this.onAccept,
    required this.onDecline,
  });

  final String challengerName;
  final int challengerAvatarIndex;
  final String categoryName;
  final int h2hYou;
  final int h2hThem;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  State<IncomingChallengeOverlay> createState() =>
      _IncomingChallengeOverlayState();
}

class _IncomingChallengeOverlayState extends State<IncomingChallengeOverlay> {
  int _secondsLeft = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) {
          timer.cancel();
          widget.onDecline();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        decoration: TextDecoration.none,
        color: AppColors.textPrimary,
      ),
      child: GestureDetector(
      onTap: widget.onDecline,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: const Color.fromRGBO(0, 0, 0, 0.7),
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent tap-through to backdrop
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color.fromRGBO(255, 191, 94, 0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pulsing avatar
                      SizedBox(
                        width: 96,
                        height: 96,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Pulsing ring
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color.fromRGBO(
                                      255, 191, 94, 0.15),
                                  width: 2,
                                ),
                              ),
                            )
                                .animate(
                                    onPlay: (c) => c.repeat(reverse: true))
                                .scale(
                                  begin: const Offset(1.0, 1.0),
                                  end: const Offset(1.08, 1.08),
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.easeInOut,
                                ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.amberGlow,
                                  width: 3,
                                ),
                              ),
                              child: RapidAvatar(
                                defaultAvatarIndex:
                                    widget.challengerAvatarIndex,
                                size: 80,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.challengerName,
                        style: AppTypography.serifH(fontSize: 22),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'wants to play!',
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Pill(
                        label: '${widget.categoryName} \u00B7 10 Rounds',
                        variant: PillVariant.amber,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Head-to-head: You ${widget.h2hYou} \u2014 Them ${widget.h2hThem}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ClayButtonSecondary(
                              label: 'Decline',
                              onPressed: widget.onDecline,
                              isFullWidth: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ClayButton(
                              label: 'Accept \u26A1',
                              onPressed: widget.onAccept,
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

void showIncomingChallenge(
  BuildContext context, {
  required String challengerName,
  required int challengerAvatarIndex,
  required String categoryName,
  required int h2hYou,
  required int h2hThem,
  required VoidCallback onAccept,
  required VoidCallback onDecline,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (_) => IncomingChallengeOverlay(
      challengerName: challengerName,
      challengerAvatarIndex: challengerAvatarIndex,
      categoryName: categoryName,
      h2hYou: h2hYou,
      h2hThem: h2hThem,
      onAccept: () {
        Navigator.of(context).pop();
        onAccept();
      },
      onDecline: () {
        Navigator.of(context).pop();
        onDecline();
      },
    ),
  );
}
