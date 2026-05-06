import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:lacarte_dashboard/data/repositories/menu_repository.dart';
import 'package:lacarte_dashboard/data/service/api_client.dart';

enum MenuStatus { idle, loading, success, error }

class MenuViewModel extends ChangeNotifier {
  final MenuRepository _menuRepository = MenuRepository();

  MenuStatus _status = MenuStatus.idle;
  String? _errorMessage;
  List<MenuItemResponse> _menuItems = [];

  MenuStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<MenuItemResponse> get menuItems => _menuItems;

  Future<void> fetchMenuItems() async {
    _setStatus(MenuStatus.loading);
    try {
      _menuItems = await _menuRepository.getMenuItems();
      _setStatus(MenuStatus.success);
    } on DioException catch (e) {
      _setError('Failed to fetch menu items: ${e.message}');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

  Future<void> createMenuItem({
    required String name,
    required String description,
    required double price,
    required int category,
    required MultipartFile image,
  }) async {
    _setStatus(MenuStatus.loading);
    try {
      final newItem = await _menuRepository.createMenuItem(
        name: name,
        description: description,
        price: price,
        category: category,
        image: image,
      );
      _menuItems.add(newItem);
      _setStatus(MenuStatus.success);
    } on DioException catch (e) {
      _setError('Failed to create menu item: ${e.message}');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

  Future<void> updateMenuItem(int id, MenuItemRequest request) async {
    _setStatus(MenuStatus.loading);
    try {
      final updatedItem = await _menuRepository.updateMenuItem(id, request);
      final index = _menuItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        _menuItems[index] = updatedItem;
      }
      _setStatus(MenuStatus.success);
    } on DioException catch (e) {
      _setError('Failed to update menu item: ${e.message}');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

  Future<void> deleteMenuItem(int id) async {
    _setStatus(MenuStatus.loading);
    try {
      await _menuRepository.deleteMenuItem(id);
      _menuItems.removeWhere((item) => item.id == id);
      _setStatus(MenuStatus.success);
    } on DioException catch (e) {
      _setError('Failed to delete menu item: ${e.message}');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

  void _setStatus(MenuStatus status) {
    _status = status;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = MenuStatus.error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
