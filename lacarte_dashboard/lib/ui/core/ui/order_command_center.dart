import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:lacarte_dashboard/ui/dashboard_ft/view_models/order_view_model.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/wigdets/build_column.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/wigdets/build_delivery_column.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/wigdets/build_standard_card.dart';

class OrderCommandCenter extends StatefulWidget {
  const OrderCommandCenter({super.key});

  @override
  State<OrderCommandCenter> createState() => _OrderCommandCenterState();
}

class _OrderCommandCenterState extends State<OrderCommandCenter> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderViewModel>().fetchOrders();
    });
    // Update UI every minute to refresh the "time elapsed" strings
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatElapsedTime(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else {
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      return '${hours}h ${minutes}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderViewModel>(
      builder: (context, viewModel, child) {
        final pendingOrders = viewModel.getOrdersByStatus('PENDING');
        final preparingOrders = viewModel.getOrdersByStatus('PREPARING');
        final servedOrders = viewModel.getOrdersByStatus('SERVED');

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
                        'Order Command Center',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E231F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Live feed and status tracking for all active orders.',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
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

              // Kanban Board Columns
              if (viewModel.status == OrderStatus.loading && viewModel.orders.isEmpty)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: BuildColumn(
                          title: 'New',
                          count: pendingOrders.length.toString(),
                          dotColor: const Color(0xFF3B5998), // Dark Blue
                          cards: pendingOrders.map((order) => BuildStandardCard(
                            id: '#${order.id}',
                            type: order.orderType,
                            time: _formatElapsedTime(order.createdAt),
                            items: order.items.map((i) => '${i.quantity}x ${i.menuItem.name}').toList(),
                            price: '\$${order.totalPrice.toStringAsFixed(2)}',
                            btnText: 'Accept',
                            isBtnPrimary: true,
                            onBtnPressed: () => viewModel.updateOrderStatus(order.id, 'PREPARING'),
                          )).toList(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: BuildColumn(
                          title: 'Preparing',
                          count: preparingOrders.length.toString(),
                          dotColor: const Color(0xFF728A7C), // Sage green
                          cards: preparingOrders.map((order) => BuildStandardCard(
                            id: '#${order.id}',
                            type: order.orderType,
                            time: _formatElapsedTime(order.createdAt),
                            items: order.items.map((i) => '${i.quantity}x ${i.menuItem.name}').toList(),
                            price: '\$${order.totalPrice.toStringAsFixed(2)}',
                            btnText: 'Mark Ready',
                            isBtnPrimary: false,
                            onBtnPressed: () => viewModel.updateOrderStatus(order.id, 'SERVED'),
                          )).toList(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: BuildColumn(
                          title: 'Ready',
                          count: servedOrders.length.toString(),
                          dotColor: const Color(0xFF728A7C),
                          cards: servedOrders.map((order) => BuildStandardCard(
                            id: '#${order.id}',
                            type: order.orderType,
                            time: _formatElapsedTime(order.createdAt),
                            items: order.items.map((i) => '${i.quantity}x ${i.menuItem.name}').toList(),
                            price: '\$${order.totalPrice.toStringAsFixed(2)}',
                            btnText: 'Dispatch',
                            isBtnPrimary: true,
                            buttonColor: const Color(0xFF2E453A),
                            onBtnPressed: () => viewModel.updateOrderStatus(order.id, 'PAID'),
                          )).toList(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Out for Delivery Column (Distinct Dark Styling)
                      const Expanded(child: BuildDeliveryColumn()),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
