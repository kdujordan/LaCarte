import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:lacarte_dashboard/data/repositories/order_repository.dart';
import 'package:lacarte_dashboard/data/service/api_client.dart';

enum OrderStatus { idle, loading, success, error }

class OrderViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();

  OrderStatus _status = OrderStatus.idle;
  String? _errorMessage;
  List<OrderResponse> _orders = [];
  OrderResponse? _selectedOrder;

  // Getters
  OrderStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<OrderResponse> get orders => _orders;
  OrderResponse? get selectedOrder => _selectedOrder;

  // Filter properties
  String? _selectedFilter;
  String? get selectedFilter => _selectedFilter;

  Future<void> fetchOrders({String? status}) async {
    _setStatus(OrderStatus.loading);
    try {
      _orders = await _orderRepository.getOrders(status: status);
      _setStatus(OrderStatus.success);
    } on DioException catch (e) {
      _setError('Failed to fetch orders: ${e.message}');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

  Future<void> fetchOrderById(int id) async {
    _setStatus(OrderStatus.loading);
    try {
      _selectedOrder = await _orderRepository.getOrderById(id);
      _setStatus(OrderStatus.success);
    } on DioException catch (e) {
      _setError('Failed to fetch order: ${e.message}');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    _setStatus(OrderStatus.loading);
    try {
      final updatedOrder = await _orderRepository.updateOrderStatus(
        orderId,
        newStatus,
      );

      // Update the order in the list
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = updatedOrder;
      }

      // Update selected order if it's the same
      if (_selectedOrder?.id == orderId) {
        _selectedOrder = updatedOrder;
      }

      _setStatus(OrderStatus.success);
      notifyListeners();
    } on DioException catch (e) {
      _setError('Failed to update order status: ${e.message}');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

  void setFilter(String? filterValue) {
    _selectedFilter = filterValue;
    if (filterValue != null && filterValue != 'ALL') {
      fetchOrders(status: filterValue);
    } else {
      fetchOrders();
    }
  }

  // Helper methods
  void _setStatus(OrderStatus status) {
    _status = status;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = OrderStatus.error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Filter orders by status
  List<OrderResponse> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  // Get order count by status
  Map<String, int> getOrderCountByStatus() {
    final Map<String, int> counts = {};
    for (var order in _orders) {
      counts[order.status] = (counts[order.status] ?? 0) + 1;
    }
    return counts;
  }

  // Get total order value
  double getTotalOrderValue() {
    return _orders.fold(0, (sum, order) => sum + order.totalPrice);
  }

  // Get average order value
  double getAverageOrderValue() {
    if (_orders.isEmpty) return 0;
    return getTotalOrderValue() / _orders.length;
  }
}
