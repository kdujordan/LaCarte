import 'package:flutter/material.dart';
import 'package:lacarte_dashboard/ui/core/ui/analytics_suite.dart';
import 'package:lacarte_dashboard/ui/core/ui/dashboard_screen.dart';
import 'package:lacarte_dashboard/ui/core/ui/menu_atelier.dart';
import 'package:lacarte_dashboard/ui/core/ui/order_command_center.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/view_models/navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:lacarte_dashboard/ui/core/ui/login_screen.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/view_models/auth_view_model.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  // Map the screens to the navigation indices
  static const List<Widget> _screens = [
    DashboardScreen(), // Index 0
    MenuAtelier(), // Index 1
    OrderCommandCenter(), // Index 2
    AnalyticsSuite(), // Index 3
  ];

  @override
  Widget build(BuildContext context) {
    // Watch the provider for state changes
    final navProvider = context.watch<NavigationProvider>();

    return Scaffold(
      body: Row(
        children: [
          // Side Navigation Bar
          Container(
            width: 80,
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1E231F),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Profile/Brand Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF728A7C),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Navigation Icons - passing the specific index for each
                _buildNavIcon(
                  Icons.grid_view_rounded,
                  0,
                  context,
                  navProvider.currentIndex,
                ),
                _buildNavIcon(
                  Icons.restaurant_menu,
                  1,
                  context,
                  navProvider.currentIndex,
                ),
                _buildNavIcon(
                  Icons.receipt_long,
                  2,
                  context,
                  navProvider.currentIndex,
                ),
                _buildNavIcon(
                  Icons.pie_chart_outline,
                  3,
                  context,
                  navProvider.currentIndex,
                ),

                const Spacer(),

                // Bottom Icons (Unlinked for now)
                _buildNavIcon(
                  Icons.settings_outlined,
                  -1,
                  context,
                  navProvider.currentIndex,
                ),
                _buildNavIcon(
                  Icons.logout,
                  -1,
                  context,
                  navProvider.currentIndex,
                  onTapOverride: () async {
                    await context.read<AuthViewModel>().logout();
                    if (!context.mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Main Content Area - dynamically switches based on the Provider index
          Expanded(child: _screens[navProvider.currentIndex]),
        ],
      ),
    );
  }

  // Updated builder to handle taps and dynamic styling
  Widget _buildNavIcon(
    IconData icon,
    int index,
    BuildContext context,
    int currentIndex, {
    VoidCallback? onTapOverride,
  }) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: onTapOverride ?? () {
        if (index != -1) {
          // -1 used for settings/logout as placeholders
          context.read<NavigationProvider>().updateIndex(index);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.white54,
            size: 24,
          ),
        ),
      ),
    );
  }
}
