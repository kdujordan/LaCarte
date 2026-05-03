import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lacarte/ui/core/themes/app_theme.dart';
import 'package:lacarte/ui/core/ui/intro_page.dart';
import 'package:lacarte/ui/core/ui/station.dart';
// import 'package:lacarte/ui/core/ui/home_page.dart';
// import 'package:lacarte/ui/core/ui/station.dart';
import 'package:lacarte/ui/lacarte_ft/view_models/auth_view_model.dart';
import 'package:lacarte/ui/lacarte_ft/view_models/menu_view_model.dart';
import 'package:lacarte/ui/lacarte_ft/view_models/order_view_model.dart';
import 'package:lacarte/ui/lacarte_ft/view_models/cart_view_model.dart';
import 'package:lacarte/data/services/order_service.dart';
import 'package:lacarte/data/services/websocket_service.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => MenuViewModel()..loadMenuInit()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(
          create: (context) => OrderViewModel(
            OrderService(),
            context.read<CartViewModel>(),
            OrderWebSocketService(),
          ),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // home: IntroPage(),
      initialRoute: '/intro',
      routes: {
        '/intro': (context) => IntroPage(),
        // '/cart': (context) => CartPage(),
        // '/order-status': (context) => OrderStatusPage(),
        '/station': (context) => Station(),
      },
    );
  }
}
