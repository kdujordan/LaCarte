import 'package:flutter/material.dart';
import 'package:lacarte/data/model/models.dart';

class CartViewModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => item.quantity);
  bool get isEmpty => _items.isEmpty;

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.subtotal);

  void addItem(MenuItem item, {String? specialRequests}) {
    final existingIndex = _items.indexWhere(
      (cartItem) => cartItem.menuItem.id == item.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
        specialRequests:
            specialRequests ?? _items[existingIndex].specialRequests,
      );
    } else {
      _items.add(
        CartItem(
          menuItem: item,
          quantity: 1,
          specialRequests: specialRequests ?? '',
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(MenuItem menuItem) {
    final idx = _items.indexWhere((c) => c.menuItem.id == menuItem.id);
    if (idx < 0) return;
    final current = _items[idx];
    if (current.quantity > 1) {
      _items[idx] = current.copyWith(quantity: current.quantity - 1);
    } else {
      _items.removeAt(idx);
    }
    notifyListeners();
  }

  void updateSpecialRequests(int menuItemId, String request) {
    final existingIndex = _items.indexWhere(
      (cartItem) => cartItem.menuItem.id == menuItemId,
    );

    if (existingIndex < 0) return;
    final current = _items[existingIndex];

    _items[existingIndex] = current.copyWith(specialRequests: request);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int quantityOf(int menuItemId) {
    final index = _items.indexWhere(
      (cartItem) => cartItem.menuItem.id == menuItemId,
    );
    if (index < 0) return 0;
    return _items[index].quantity;
  }
}
