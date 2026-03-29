import 'package:flutter/material.dart';

import 'screens/debug/widget_catalog_screen.dart';
import 'theme/app_theme.dart';

class RapidApp extends StatelessWidget {
  const RapidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rapid',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const WidgetCatalogScreen(),
    );
  }
}
