import 'package:flutter/material.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/payment_method.dart';

class PaymentGrid extends StatelessWidget {
  final PaymentMethod selected;
  final bool locked;
  final ValueChanged<PaymentMethod> onSelect;
  const PaymentGrid({
    super.key,
    required this.selected,
    required this.locked,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 3.0,
      children: PaymentMethod.values.map((method) {
        final isSelected = selected == method;
        return GestureDetector(
          onTap: locked ? null : () => onSelect(method),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black87 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Colors.black87
                    : Colors.black.withOpacity(0.1),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(
                  method.icon,
                  size: 18,
                  color: isSelected ? Colors.white : Colors.black54,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    method.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
