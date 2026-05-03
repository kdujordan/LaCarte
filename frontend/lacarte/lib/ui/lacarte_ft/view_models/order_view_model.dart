// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lacarte/data/model/models.dart';
import 'package:lacarte/data/services/order_service.dart';
import 'package:lacarte/data/services/websocket_service.dart';
import 'package:lacarte/ui/lacarte_ft/view_models/cart_view_model.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderService _service;
  final CartViewModel _cart;
  final OrderWebSocketService _ws;

  StreamSubscription<Map<String, dynamic>>? _wsSub;

  OrderViewModel(this._service, this._cart, this._ws) {
    _subscribeToWebSokcet();
  }

  List<Order> _orders = [];
  Order? _lastPlacedOrder;
  bool _isPlacingOrder = false;
  bool _isLoadingOrders = false;
  String? _error;

  Map<int, OrderStatus> _liveStatuses = {};

  List<Order> get orders => List.unmodifiable(_orders);
  Order? get lastPlacedOrder => _lastPlacedOrder;
  bool get isPlacingOrder => _isPlacingOrder;
  bool get isLoadingOrders => _isLoadingOrders;
  String? get error => _error;

  OrderStatus liveStatusOf(int orderId) =>
      _liveStatuses[orderId] ??
      _orders
          .firstWhere(
            (o) => o.id == orderId,
            orElse: () => Order(
              id: orderId,
              status: OrderStatus.pending,
              totalPrice: 0,
              createdAt: DateTime.now(),
              orderType: OrderType.orderForSelf,
              items: [],
            ),
          )
          .status;
  Future<bool> placeOrder({required OrderType orderType}) async {
    if (_cart.isEmpty) return false;

    _isPlacingOrder = true;
    _error = null;
    notifyListeners();

    try {
      _lastPlacedOrder = await _service.placeOrder(
        cartItems: _cart.items,
        orderType: orderType,
      );
      _orders.insert(0, _lastPlacedOrder!);
      _cart.clear();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isPlacingOrder = false;
      notifyListeners();
    }
  }

  Future<void> cancelActiveOrder() async {
    final order = _lastPlacedOrder;
    if (order == null) return;
    _liveStatuses[order.id] = OrderStatus.cancelled;
    notifyListeners();
    try {
      await _service.updateOrderStatus(order.id, 'cancelled');
    } catch (_) {
      // revert on failure
      _liveStatuses.remove(order.id);
      notifyListeners();
    }
  }

  Future<void> loadOrders() async {
    _isLoadingOrders = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await _service.getOrders();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingOrders = false;
      notifyListeners();
    }
  }

  void _subscribeToWebSokcet() {
    _ws.connect();
    _wsSub = _ws.stream.listen((event) {
      final message = event["message"] as Map<String, dynamic>?;
      if (message == null) return;

      final orderId = message["order_id"] as int?;
      final statusStr = message["status"] as String?;

      if (orderId == null || statusStr == null) return;

      _liveStatuses[orderId] = OrderStatusParsing.fromString(statusStr);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _wsSub?.cancel();
    _ws.disconnect();
    super.dispose();
  }
}
