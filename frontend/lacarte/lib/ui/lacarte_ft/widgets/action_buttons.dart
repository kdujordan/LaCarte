import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final bool orderPlaced;
  final bool isServed;
  final bool isCancelled;
  final bool isPlacing;
  final bool cartEmpty;
  final VoidCallback onPlace;
  final VoidCallback onCancel;
  const ActionButtons({
    super.key,
    required this.orderPlaced,
    required this.isServed,
    required this.isCancelled,
    required this.isPlacing,
    required this.cartEmpty,
    required this.onPlace,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final placeBtnDisabled = orderPlaced || isPlacing || cartEmpty;
    final cancelBtnDisabled = isServed || isCancelled;
    return Row(
      children: [
        // Place order
        Expanded(
          flex: 3,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: placeBtnDisabled
                  ? Colors.black26
                  : Colors.black87,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
            ),
            onPressed: placeBtnDisabled ? null : onPlace,
            icon: isPlacing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.shopping_cart_checkout, size: 18),
            label: Text(
              isPlacing ? 'Placing...' : 'Place order',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Cancel
        Expanded(
          flex: 2,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: cancelBtnDisabled
                  ? Colors.black26
                  : Colors.red.shade600,
              side: BorderSide(
                color: cancelBtnDisabled ? Colors.black12 : Colors.red.shade200,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
            ),
            onPressed: cancelBtnDisabled ? null : onCancel,
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}
