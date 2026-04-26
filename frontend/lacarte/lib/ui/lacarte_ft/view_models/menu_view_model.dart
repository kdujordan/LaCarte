import 'package:flutter/material.dart';
import 'package:lacarte/data/services/menu_service.dart';

class MenuViewModel extends ChangeNotifier {
  final MenuService _menuService = MenuService();

  List<dynamic> categories = [];
  List<dynamic> menuItems = [];
  bool isLoading = false;

  Future<void> loadMenuInit() async {
    isLoading = true;
    notifyListeners();

    try {
      categories = await _menuService.getCategories();

      if (categories.isNotEmpty) {
        await loadItemsForCategory(categories[0]['id']);
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadItemsForCategory(int categoryId) async {
    isLoading = true;
    notifyListeners();

    menuItems = await _menuService.getMenuItems(categoryId: categoryId);
    isLoading = false;
    notifyListeners();
  }
}
