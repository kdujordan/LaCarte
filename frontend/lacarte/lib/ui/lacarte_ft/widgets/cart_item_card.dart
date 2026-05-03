// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:lacarte/data/model/models.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/qty_button.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final bool locked;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  const CartItemCard({
    super.key,
    required this.item,
    required this.locked,
    required this.onIncrement,
    required this.onDecrement,
  });

  Widget _placeholder() => Container(
    width: 60,
    height: 60,
    color: const Color(0xFFF0F0F0),
    child: const Icon(Icons.fastfood, color: Colors.black26),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: item.menuItem.imageUrl.isNotEmpty
                ? Image.network(
                    item.menuItem.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuItem.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.menuItem.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
                const SizedBox(height: 4),
                Text(
                  'UGX ${item.menuItem.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Quantity controls
          if (!locked)
            Row(
              children: [
                QtyButton(icon: Icons.remove, onTap: onDecrement),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                QtyButton(icon: Icons.add, onTap: onIncrement),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '×${item.quantity}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
