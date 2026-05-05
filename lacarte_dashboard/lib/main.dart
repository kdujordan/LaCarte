import 'package:flutter/material.dart';
import 'package:lacarte_dashboard/ui/core/ui/login_screen.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/view_models/analytics_view_model.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/view_models/navigation_provider.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/view_models/order_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
        ChangeNotifierProvider(create: (_) => AnalyticsViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'La Carte Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(
            0xFFF4F2EE,
          ), // Soft beige background
          fontFamily: 'Inter', // Recommend adding Inter to pubspec.yaml
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1E231F), // Dark charcoal
            secondary: Color(0xFF728A7C), // Sage green
            surface: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF728A7C)),
            ),
            hintStyle: TextStyle(color: Colors.grey.shade500),
            prefixIconColor: Colors.grey.shade500,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E231F),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
