import 'package:flutter/material.dart';
import 'package:lacarte/data/model/models.dart';
import 'package:lacarte/ui/lacarte_ft/view_models/cart_view_model.dart';
import 'package:provider/provider.dart';

class MenuItemDetailsPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const MenuItemDetailsPage({super.key, required this.item});

  @override
  State<MenuItemDetailsPage> createState() => _MenuItemDetailsPageState();
}

class _MenuItemDetailsPageState extends State<MenuItemDetailsPage> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        behavior: SnackBarBehavior.floating,
        shape: const StadiumBorder(),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartVm = context.watch<CartViewModel>();
    int qty = cartVm.quantityOf(widget.item['id']);
    final menuItem = MenuItem.fromJson(widget.item);

    // const Color buttonColor = Color(0xFFCADBB7);
    const Color accentIconColor = Color(0xFFD6A556);
    final String heroTag = 'item_${widget.item['id'] ?? widget.item['name']}';

    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE (Bottom Layer)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.2,
            child: ClipRRect(
              child: Hero(
                tag: heroTag,
                child: Image.network(
                  widget.item['image_url'] ?? 'https://via.placeholder.com/400',
                  fit: BoxFit
                      .cover, // Makes the image cover the entire background
                ),
              ),
            ),
          ),

          // Optional: A subtle gradient overlay so the top buttons remain visible
          // if the image happens to be very bright.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                ),
              ),
            ),
          ),

          // 2. CUSTOM APP BAR (Top Layer)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, size: 18),
                      ),
                    ),

                    // Title
                    const Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Changed to white for visibility
                      ),
                    ),

                    // Cart Button
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_basket_outlined,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. BOTTOM DETAILS SHEET (Top Layer)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                30.0,
                30.0,
                30.0,
                50.0,
              ), // Extra padding at bottom for safe area
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                // Optional: add a subtle shadow so it pops off the background
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Wrap content height
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _itemNameToString(widget.item['name']),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _categoryToString(widget.item['category_name']),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${_formatPrice(widget.item['price'])}",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Row(
                        children: [
                          _buildQuantityButton(
                            icon: Icons.remove,
                            onTap: _decrementQuantity,
                            color: accentIconColor,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            "$_quantity",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 15),
                          _buildQuantityButton(
                            icon: Icons.add,
                            onTap: _incrementQuantity,
                            color: accentIconColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        qty = _quantity;
                        for (int i = 0; i < _quantity; i++) {
                          cartVm.addItem(menuItem);
                        }
                        _showToast("Added $qty ${widget.item['name']} to cart");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_basket_outlined, size: 20),
                          const SizedBox(width: 10),
                          const Text(
                            "Buy Now",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _itemNameToString(dynamic name) {
    if (name == null) return 'Unknown Item';
    if (name is String) return name;
    return name.toString();
  }

  String _categoryToString(dynamic category) {
    if (category == null) return 'Category';
    if (category is String) return category;
    if (category is int) return category.toString();
    return 'Category';
  }

  String _formatPrice(dynamic price) {
    if (price == null) return '0.00';
    if (price is double) return price.toStringAsFixed(2);
    if (price is int) return price.toDouble().toStringAsFixed(2);
    if (price is String) {
      try {
        return double.parse(price).toStringAsFixed(2);
      } catch (e) {
        return '0.00';
      }
    }
    return '0.00';
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 1.5),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
