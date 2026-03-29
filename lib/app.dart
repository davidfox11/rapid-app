import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'theme/app_typography.dart';
import 'widgets/screen_background.dart';

class RapidApp extends StatelessWidget {
  const RapidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rapid',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: ScreenBackground(
        child: Center(
          child: Text(
            'Rapid.',
            style: AppTypography.serifH(fontSize: 48),
          ),
        ),
      ),
    );
  }
}
