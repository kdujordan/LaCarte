import 'package:dio/dio.dart';
import 'package:lacarte/data/services/api_client.dart';

class MenuService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getCategories() async {
    try {
      final response = await _apiClient.dio.get('category-menu/categories/');
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to get menu');
    }
  }

  Future<List<dynamic>> getMenuItems({int? categoryId}) async {
    String endpoint = "category-menu/";

    if (categoryId != null) {
      endpoint += '?category=$categoryId'; // using the Django filter Backend
    }

    final response = await _apiClient.dio.get(endpoint);
    return response.data;
  }
}
