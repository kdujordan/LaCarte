import 'package:flutter/material.dart';
import 'package:lacarte/data/model/models.dart';
import 'package:lacarte/ui/lacarte_ft/view_models/auth_view_model.dart';
import 'package:lacarte/ui/lacarte_ft/view_models/cart_view_model.dart';
import 'package:lacarte/ui/lacarte_ft/view_models/order_view_model.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/action_buttons.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/cart_item_card.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/empty_cart.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/feedback_section.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/order_type_toggle.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/payment_grid.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/payment_method.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/section_label.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/status_section.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/table_bagde.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/total_card.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  PaymentMethod _selectedPayment = PaymentMethod.cash;
  OrderType _orderType = OrderType.orderForSelf;

  // Feedback
  double _foodRating = 4;
  double _speedRating = 3;
  double _valueRating = 4;
  final _commentCtrl = TextEditingController();
  bool _feedbackSubmitted = false;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        behavior: SnackBarBehavior.floating,
        shape: const StadiumBorder(),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _placeOrder() async {
    final orderVm = context.read<OrderViewModel>();
    final ok = await orderVm.placeOrder(orderType: _orderType);
    if (!mounted) return;
    if (ok) {
      _showToast('Order placed! Kitchen is notified 🍳');
    } else {
      _showToast(orderVm.error ?? 'Failed to place order');
    }
  }

  void _cancelOrder() {
    context.read<OrderViewModel>().cancelActiveOrder();
    _showToast('Order cancelled');
  }

  void _submitFeedback() {
    // TODO: wire to POST /api/feedback/
    setState(() => _feedbackSubmitted = true);
    _showToast('Feedback submitted. Thank you!');
  }

  @override
  Widget build(BuildContext context) {
    final cartVm = context.watch<CartViewModel>();
    final orderVm = context.watch<OrderViewModel>();
    final session = context.watch<AuthViewModel>().session;

    final order = orderVm.lastPlacedOrder;
    final orderPlaced = order != null;
    final liveStatus = order != null ? orderVm.liveStatusOf(order.id) : null;
    final isServed = liveStatus == OrderStatus.served;
    final isCancelled = liveStatus == OrderStatus.cancelled;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text(
          'My order',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          if (!orderPlaced)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.black54),
              onPressed: () {
                cartVm.clear();
                _showToast('Cart cleared');
              },
            ),
        ],
      ),
      body: cartVm.isEmpty && !orderPlaced
          ? EmptyCart(onBrowse: () => Navigator.of(context).pop())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                // ── Table badge ──────────────────────────────────────────
                if (session != null) ...[
                  TableBagde(tableNumber: session.tableNumber),
                  const SizedBox(height: 12),
                ],

                // ── Cart items ───────────────────────────────────────────
                ...cartVm.items.map(
                  (item) => CartItemCard(
                    item: item,
                    locked: orderPlaced,
                    onIncrement: () => cartVm.addItem(item.menuItem),
                    onDecrement: () => cartVm.removeItem(item.menuItem),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Order type toggle ────────────────────────────────────
                if (!orderPlaced) ...[
                  SectionLabel(text: 'Order type'),
                  const SizedBox(height: 8),
                  OrderTypeToggle(
                    selected: _orderType,
                    onChanged: (t) => setState(() => _orderType = t),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Payment method ───────────────────────────────────────
                SectionLabel(text: 'Payment method'),
                const SizedBox(height: 8),
                PaymentGrid(
                  selected: _selectedPayment,
                  locked: orderPlaced,
                  onSelect: (p) => setState(() => _selectedPayment = p),
                ),

                const SizedBox(height: 16),

                // ── Totals ───────────────────────────────────────────────
                TotalCard(cartVm: cartVm),

                const SizedBox(height: 16),

                // ── Action buttons ───────────────────────────────────────
                ActionButtons(
                  orderPlaced: orderPlaced,
                  isServed: isServed,
                  isCancelled: isCancelled,
                  isPlacing: orderVm.isPlacingOrder,
                  cartEmpty: cartVm.isEmpty,
                  onPlace: _placeOrder,
                  onCancel: _cancelOrder,
                ),

                // ── Status section (post-order) ──────────────────────────
                if (orderPlaced) ...[
                  const SizedBox(height: 24),
                  StatusSection(order: order, liveStatus: liveStatus!),
                ],

                // ── Feedback section (post-order) ────────────────────────
                if (orderPlaced) ...[
                  const SizedBox(height: 24),
                  FeedbackSection(
                    foodRating: _foodRating,
                    speedRating: _speedRating,
                    valueRating: _valueRating,
                    commentCtrl: _commentCtrl,
                    submitted: _feedbackSubmitted,
                    onFoodChanged: (v) => setState(() => _foodRating = v),
                    onSpeedChanged: (v) => setState(() => _speedRating = v),
                    onValueChanged: (v) => setState(() => _valueRating = v),
                    onSubmit: _submitFeedback,
                  ),

                  const SizedBox(height: 100),
                ],
              ],
            ),
    );
  }
}
