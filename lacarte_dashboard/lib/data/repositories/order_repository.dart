import 'package:dio/dio.dart';
import 'package:lacarte_dashboard/data/service/api_client.dart';
import 'package:lacarte_dashboard/data/service/dio_client.dart';

class OrderRepository {
  final ApiClient _apiClient = DioClient().apiClient;

  Future<List<OrderResponse>> getOrders({
    String? status,
    String? ordering,
  }) async {
    try {
      return await _apiClient.getOrders(status, ordering);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderResponse> getOrderById(int id) async {
    try {
      return await _apiClient.getOrderById(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderResponse> updateOrderStatus(int id, String status) async {
    try {
      return await _apiClient.updateOrderStatus(
        id,
        UpdateOrderStatusRequest(status: status),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> handleOrderError(DioException error) {
    // Handle specific error scenarios
    if (error.response?.statusCode == 401) {
      // Unauthorized
      throw UnauthorizedException('Unauthorized access');
    } else if (error.response?.statusCode == 403) {
      // Forbidden
      throw ForbiddenException('Access forbidden');
    } else if (error.response?.statusCode == 404) {
      // Not found
      throw NotFoundException('Order not found');
    } else if (error.response?.statusCode == 500) {
      // Server error
      throw ServerException('Server error occurred');
    }
    throw Exception('An error occurred: ${error.message}');
  }
}

// Custom Exceptions
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);

  @override
  String toString() => message;
}

class ForbiddenException implements Exception {
  final String message;
  ForbiddenException(this.message);

  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);

  @override
  String toString() => message;
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => message;
}
