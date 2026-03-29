import 'dart:ui';

import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color.fromRGBO(255, 255, 255, 0.10),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class GlassCardSmall extends StatelessWidget {
  const GlassCardSmall({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color.fromRGBO(255, 255, 255, 0.10),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
