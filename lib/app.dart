import 'package:flutter/material.dart';

import 'config/routes.dart';
import 'theme/app_theme.dart';

class RapidApp extends StatelessWidget {
  const RapidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rapid',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
