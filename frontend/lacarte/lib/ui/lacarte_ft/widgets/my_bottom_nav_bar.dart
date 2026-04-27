import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class MyBottomNavBar extends StatelessWidget {
  MyBottomNavBar({super.key, required this.onTabChange});
  void Function(int)? onTabChange;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      // decoration: BoxDecoration(color: colorScheme.primary),
      child: GNav(
        color: colorScheme.secondary,
        tabBorder: Border.all(color: colorScheme.tertiary),
        activeColor: colorScheme.secondary,
        tabActiveBorder: Border.all(color: colorScheme.primary),
        tabBackgroundColor: colorScheme.tertiary,
        gap: 5,
        mainAxisAlignment: MainAxisAlignment.center,
        // padding: EdgeInsetsGeometry.only(bottom: 15.0),
        tabs: const [
          GButton(icon: Icons.restaurant_menu, text: 'menu'),
          GButton(icon: Icons.lunch_dining, text: 'Orders'),
          GButton(icon: Icons.movie, text: 'Explore'),
          // GButton(icon: Icons.settings_outlined, text: 'Settings'),
        ],
        onTabChange: (value) => onTabChange!(value),
      ),
    );
  }
}
