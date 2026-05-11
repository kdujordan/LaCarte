import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/view_models/menu_view_model.dart';
// import 'package:lacarte_dashboard/data/service/api_client.dart';
import 'package:intl/intl.dart';

class MenuAtelier extends StatefulWidget {
  const MenuAtelier({super.key});

  @override
  State<MenuAtelier> createState() => _MenuAtelierState();
}

class _MenuAtelierState extends State<MenuAtelier> {
  String _selectedTab = 'All Items';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuViewModel>().fetchMenuItems();
    });
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '\$').format(amount);
  }

  String _getCategoryName(int categoryId) {
    switch (categoryId) {
      case 1:
        return 'Appetizers';
      case 2:
        return 'Mains';
      case 3:
        return 'Desserts';
      case 4:
        return 'Drinks';
      default:
        return 'Uncategorized';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuViewModel>(
      builder: (context, menuVM, child) {
        final allItems = menuVM.menuItems;
        final displayedItems = _selectedTab == 'All Items'
            ? allItems
            : allItems
                  .where(
                    (item) => _getCategoryName(item.category) == _selectedTab,
                  )
                  .toList();

        return Padding(
          padding: const EdgeInsets.only(
            top: 32.0,
            right: 32.0,
            bottom: 32.0,
            left: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Menu Atelier',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E231F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage your digital catalog, availability, and pricing.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 250,
                        height: 40,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search orders, items...',
                            hintStyle: const TextStyle(fontSize: 13),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=11',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Categories & Action Bar
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildTab(
                          'All Items',
                          isActive: _selectedTab == 'All Items',
                        ),
                        _buildTab(
                          'Appetizers',
                          isActive: _selectedTab == 'Appetizers',
                        ),
                        _buildTab('Mains', isActive: _selectedTab == 'Mains'),
                        _buildTab(
                          'Desserts',
                          isActive: _selectedTab == 'Desserts',
                        ),
                        _buildTab('Drinks', isActive: _selectedTab == 'Drinks'),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text(
                        'New Item',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF728A7C), // Sage green
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio:
                      0.85, // Adjust this to match exact proportions
                  children: [
                    // 1. Upload Photography Card
                    _buildActionCard(
                      icon: Icons.add_photo_alternate_outlined,
                      title: 'Upload Food Photography',
                      subtitle:
                          'Drag and drop new images here to quickly create menu items.',
                      btnText: 'Browse Files',
                      isDashed: false,
                      bgColor: const Color(0xFFF4F2EE),
                    ),

                    // Dynamic items
                    ...displayedItems.map((item) {
                      return _buildItemCard(
                        title: item.name,
                        price: _formatCurrency(item.price),
                        description: item.description,
                        tag: _getCategoryName(item.category),
                        isAvailable: item.isAvailable,
                      );
                    }),

                    // Empty space to maintain grid pattern if needed
                    // const SizedBox.shrink(),

                    // 6. Manual Entry Card
                    _buildActionCard(
                      icon: Icons.add,
                      title: 'Manual Entry',
                      subtitle: 'Create an item without a photo to start.',
                      btnText: 'Add Details',
                      isDashed: true,
                      bgColor: Colors.transparent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab(String title, {bool isActive = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E231F) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String btnText,
    required bool isDashed,
    required Color bgColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDashed ? Colors.grey.shade300 : Colors.transparent,
          width: isDashed ? 2 : 0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.grey.shade600, size: 28),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                btnText,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard({
    required String title,
    required String price,
    required String description,
    required String tag,
    required bool isAvailable,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isAvailable
                      ? const Color(0xFF00C853)
                      : Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isAvailable ? 'Available' : 'Sold Out',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isAvailable ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Title & Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F2EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),
          // Bottom Row (Tag & Actions)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2EFE9), // Sage light
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Color(0xFF728A7C),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    isAvailable
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
