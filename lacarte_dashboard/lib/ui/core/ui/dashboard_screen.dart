import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/view_models/analytics_view_model.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/view_models/order_view_model.dart';
// import 'package:lacarte_dashboard/data/service/api_client.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsViewModel>().fetchAllAnalytics();
      context.read<OrderViewModel>().fetchOrders();
    });
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '\$').format(amount);
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return const Color(0xFFF4F2EE);
      case 'PREPARING':
        return const Color(0xFFE2EFE9);
      case 'READY':
        return const Color(0xFFD1E8E2);
      case 'COMPLETED':
        return const Color(0xFFC4DFE6);
      default:
        return const Color(0xFFF4F2EE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AnalyticsViewModel, OrderViewModel>(
      builder: (context, analyticsVM, orderVM, child) {
        if ((analyticsVM.isLoading && !analyticsVM.isAllDataLoaded) || 
            (orderVM.status == OrderStatus.loading && orderVM.orders.isEmpty)) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF728A7C)),
          );
        }

        final revenue = analyticsVM.getTotalRevenue();
        final revenueChange = analyticsVM.getRevenueChange();
        final activeOrders = orderVM.orders
            .where(
              (o) =>
                  o.status.toUpperCase() != 'COMPLETED' &&
                  o.status.toUpperCase() != 'CANCELLED',
            )
            .length;

        // Orders change logic is placeholder as it's not in OrderVM, but we can use AnalyticsVM order change
        final orderChange = analyticsVM.getOrderChange();

        final topItems = analyticsVM.getTopMenuItems(limit: 1);
        final trendingItemName = topItems.isNotEmpty
            ? topItems.first.menuItem
            : 'No Data';
        final trendingItemSales = topItems.isNotEmpty
            ? topItems.first.salesCount
            : 0;

        final liveOrders = orderVM.orders
            .where(
              (o) =>
                  o.status.toUpperCase() != 'COMPLETED' &&
                  o.status.toUpperCase() != 'CANCELLED',
            )
            .take(3)
            .toList();

        // Calculate Dining Capacity
        final activeSessions = orderVM.orders
            .where((o) => o.session != null && o.session!.isActive && o.session!.table != null)
            .map((o) => o.session!.table!.id)
            .toSet();
        final int occupiedTablesCount = activeSessions.length;
        const int totalTables = 56; // Assume 56 total tables based on design
        final double occupancyRate = totalTables > 0 ? occupiedTablesCount / totalTables : 0.0;

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
                        'Hello, Chef!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E231F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Here is what is happening at your restaurant today.',
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
                              borderRadius: BorderRadius.all(
                                Radius.circular(200),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Icon(
                                Icons.search_rounded,
                                size: 20,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
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
                        ), // Placeholder avatar
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Main Dashboard Grid
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column (Revenue, Sales Volume, Live Orders)
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricCard(
                                  'Revenue Today',
                                  _formatCurrency(revenue),
                                  '${revenueChange >= 0 ? '+' : ''}${revenueChange.toStringAsFixed(1)}% vs yesterday',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildMetricCard(
                                  'Active Orders',
                                  '$activeOrders',
                                  '${orderChange >= 0 ? '+' : ''}${orderChange.toStringAsFixed(1)}% vs yesterday',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            flex: 2,
                            child: _buildContainer(
                              child: const Center(
                                child: Text(
                                  'Sales Volume Chart Placeholder',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            flex: 3,
                            child: _buildContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Live Orders',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'View All',
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 32),
                                  if (liveOrders.isEmpty)
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          'No active orders right now',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ...liveOrders.map((order) {
                                    String itemsText = order.items
                                        .map(
                                          (i) =>
                                              '${i.quantity}x ${i.menuItem.name}',
                                        )
                                        .join(', ');
                                    if (itemsText.isEmpty)
                                      itemsText = 'No items';
                                    return _buildLiveOrderItem(
                                      '${order.id}',
                                      itemsText,
                                      _getTimeAgo(order.createdAt),
                                      order.status,
                                      _getStatusColor(order.status),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Right Column (Trending Item, Dining Capacity, Quick Stats)
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          // Trending Item Card (Dark Theme)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E231F),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Trending Item',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  trendingItemName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Top selling item with $trendingItemSales orders. Consider updating prep limits.',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Manage Item',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Bottom Right Row
                          Expanded(
                            child: Row(
                              children: [
                                // Dining Capacity
                                Expanded(
                                  child: _buildContainer(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: CircularProgressIndicator(
                                                value: occupancyRate,
                                                strokeWidth: 8,
                                                backgroundColor:
                                                    Colors.grey.shade200,
                                                color: const Color(0xFF728A7C),
                                              ),
                                            ),
                                            Text(
                                              '${(occupancyRate * 100).toInt()}%',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 24),
                                        const Text(
                                          'Dining Capacity',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '$occupiedTablesCount of $totalTables tables occupied. Expect wait times to increase.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 12,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Delivery Stats
                                Expanded(
                                  child: _buildContainer(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          activeOrders.toString(),
                                          style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Spacer(),
                                        if (liveOrders.isNotEmpty)
                                          _buildDeliveryStat(
                                            'Order #${liveOrders[0].id}',
                                            _getTimeAgo(
                                              liveOrders[0].createdAt,
                                            ),
                                          ),
                                        const SizedBox(height: 16),
                                        if (liveOrders.length > 1)
                                          _buildDeliveryStat(
                                            'Order #${liveOrders[1].id}',
                                            _getTimeAgo(
                                              liveOrders[1].createdAt,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }

  Widget _buildMetricCard(String title, String value, String trend) {
    return _buildContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            trend,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveOrderItem(
    String orderId,
    String items,
    String time,
    String status,
    Color statusColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F2EE),
              shape: BoxShape.circle,
            ),
            child: Text(
              orderId,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  items,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryStat(String order, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          order,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        Text(time, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
