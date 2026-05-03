import 'package:flutter/material.dart';

class EmptyCart extends StatelessWidget {
  final VoidCallback onBrowse;
  const EmptyCart({super.key, required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: Colors.black26,
          ),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onBrowse, child: const Text('Browse menu')),
        ],
      ),
    );
  }
}
