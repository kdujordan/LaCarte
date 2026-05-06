import 'package:dio/dio.dart';
import 'package:lacarte_dashboard/data/service/api_client.dart';
import 'package:lacarte_dashboard/data/service/dio_client.dart';

class MenuRepository {
  final DioClient _dioClient = DioClient();

  Future<List<MenuItemResponse>> getMenuItems() async {
    return await _dioClient.apiClient.getMenuItems();
  }

  Future<MenuItemResponse> getMenuItemById(int id) async {
    return await _dioClient.apiClient.getMenuItemById(id);
  }

  Future<MenuItemResponse> createMenuItem({
    required String name,
    required String description,
    required double price,
    required int category,
    required MultipartFile image,
  }) async {
    return await _dioClient.apiClient.createMenuItem(
      name,
      description,
      price,
      category,
      image,
    );
  }

  Future<MenuItemResponse> updateMenuItem(
    int id,
    MenuItemRequest request,
  ) async {
    return await _dioClient.apiClient.updateMenuItem(id, request);
  }

  Future<void> deleteMenuItem(int id) async {
    await _dioClient.apiClient.deleteMenuItem(id);
  }
}
