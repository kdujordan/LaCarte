import 'package:flutter/material.dart';
import 'package:lacarte/ui/lacarte_ft/view_models/cart_view_model.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/total_row.dart';

class TotalCard extends StatelessWidget {
  final CartViewModel cartVm;
  const TotalCard({super.key, required this.cartVm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          TotalRow(
            label: 'Subtotal',
            value: 'UGX ${cartVm.totalPrice.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 8),
          TotalRow(label: 'Delivery', value: 'UGX 0'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Colors.black12),
          ),
          TotalRow(
            label: 'Total price',
            value: 'UGX ${cartVm.totalPrice.toStringAsFixed(0)}',
            bold: true,
          ),
        ],
      ),
    );
  }
}
