import 'package:flutter/material.dart';
import 'package:lacarte/ui/core/themes/app_theme.dart';

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
      home: Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Hello World!')),
      ),
    );
  }
}
