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
  List<CategoryResponse> _categories = [];

  MenuStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<MenuItemResponse> get menuItems => _menuItems;
  List<CategoryResponse> get categories => _categories;

  Future<void> fetchAllData() async {
    _setStatus(MenuStatus.loading);
    try {
      final itemsFuture = _menuRepository.getMenuItems();
      final categoriesFuture = _menuRepository.getCategories();

      final results = await Future.wait([itemsFuture, categoriesFuture]);

      _menuItems = results[0] as List<MenuItemResponse>;
      _categories = results[1] as List<CategoryResponse>;

      _setStatus(MenuStatus.success);
    } on DioException catch (e) {
      _setError('Failed to fetch data: ${e.message}');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

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

  // ==================== Categories ====================

  Future<void> fetchCategories() async {
    _setStatus(MenuStatus.loading);
    try {
      _categories = await _menuRepository.getCategories();
      _setStatus(MenuStatus.success);
    } on DioException catch (e) {
      _setError('Failed to fetch categories: ${e.message}');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

  Future<void> createCategory(CategoryRequest request) async {
    _setStatus(MenuStatus.loading);
    try {
      final newCategory = await _menuRepository.createCategory(request);
      _categories.add(newCategory);
      _setStatus(MenuStatus.success);
    } on DioException catch (e) {
      _setError('Failed to create category: ${e.message}');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

  Future<void> updateCategory(int id, CategoryRequest request) async {
    _setStatus(MenuStatus.loading);
    try {
      final updatedCategory = await _menuRepository.updateCategory(id, request);
      final index = _categories.indexWhere((item) => item.id == id);
      if (index != -1) {
        _categories[index] = updatedCategory;
      }
      _setStatus(MenuStatus.success);
    } on DioException catch (e) {
      _setError('Failed to update category: ${e.message}');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

  Future<void> deleteCategory(int id) async {
    _setStatus(MenuStatus.loading);
    try {
      await _menuRepository.deleteCategory(id);
      _categories.removeWhere((item) => item.id == id);
      _setStatus(MenuStatus.success);
    } on DioException catch (e) {
      _setError('Failed to delete category: ${e.message}');
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
