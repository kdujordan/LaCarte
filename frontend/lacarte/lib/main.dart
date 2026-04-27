import 'package:flutter/material.dart';
import 'package:lacarte/ui/core/themes/app_theme.dart';
// import 'package:lacarte/ui/core/ui/home_page.dart';
import 'package:lacarte/ui/core/ui/station.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Station(),
    );
  }
}
