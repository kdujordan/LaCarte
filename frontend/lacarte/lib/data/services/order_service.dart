import 'package:dio/dio.dart';
import 'package:lacarte/data/model/models.dart';
import 'package:lacarte/data/services/api_client.dart';

class OrderService {
  final ApiClient _apiClient = ApiClient();

  Future<Order> placeOrder({
    required List<CartItem> cartItems,
    required OrderType orderType,
  }) async {
    final items = cartItems
        .map(
          (c) => {
            'menu_item': c.menuItem.id,
            'quantity': c.quantity,
            'special_requests': c.specialRequests,
          },
        )
        .toList();

    final totalPrice = cartItems.fold<double>(
      0.0,
      (sum, item) => sum + item.subtotal,
    );

    final body = {
      'items': items,
      'total_price': totalPrice,
      'order_type': orderType == OrderType.orderForSelf
          ? 'order_for_self'
          : 'order_for_others',
    };

    try {
      final response = await _apiClient.dio.post('order/', data: body);

      return Order.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to create order');
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      final response = await _apiClient.dio.get('order/');
      return (response.data as List<dynamic>)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to get orders');
    }
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    await _apiClient.dio.patch(
      'order-update-status/$orderId/update_status/',
      data: {'status': newStatus},
    );
  }
}
