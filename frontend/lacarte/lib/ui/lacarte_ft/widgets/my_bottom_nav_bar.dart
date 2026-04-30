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
      // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.tertiary,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      // decoration: BoxDecoration(color: colorScheme.primary),
      child: GNav(
        color: colorScheme.secondary,
        tabBorder: Border.all(color: colorScheme.primary),
        activeColor: colorScheme.secondary,
        tabActiveBorder: Border.all(color: colorScheme.secondary),
        tabBackgroundColor: colorScheme.surface,
        gap: 5,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        padding: EdgeInsetsGeometry.symmetric(vertical: 12.0, horizontal: 20.0),
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
