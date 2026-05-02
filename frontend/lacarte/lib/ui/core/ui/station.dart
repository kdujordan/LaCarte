import 'package:flutter/material.dart';
import 'package:lacarte/ui/core/ui/categories_section.dart';
import 'package:lacarte/ui/core/ui/explore_page.dart';
import 'package:lacarte/ui/core/ui/home_page.dart';
import 'package:lacarte/ui/core/ui/orders_page.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/my_bottom_nav_bar.dart';

class Station extends StatefulWidget {
  const Station({super.key});

  @override
  State<Station> createState() => _StationState();
}

class _StationState extends State<Station> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    CategoriesSection(),
    OrdersPage(),
    ExplorePage(),
  ];

  void onTabChange(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 20.0,
            ),
            child: MyBottomNavBar(onTabChange: (index) => onTabChange(index)),
          ),
        ),
      ),
    );
  }
}
