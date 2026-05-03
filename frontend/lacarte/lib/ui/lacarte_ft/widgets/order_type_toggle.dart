import 'package:flutter/material.dart';
import 'package:lacarte/data/model/models.dart';

class OrderTypeToggle extends StatelessWidget {
  final OrderType selected;
  final ValueChanged<OrderType> onChanged;
  const OrderTypeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<OrderType>(
      style: SegmentedButton.styleFrom(
        backgroundColor: Colors.white,
        selectedBackgroundColor: Colors.black87,
        selectedForegroundColor: Colors.white,
        foregroundColor: Colors.black87,
        side: const BorderSide(color: Colors.black12),
        shape: const StadiumBorder(),
      ),
      segments: const [
        ButtonSegment(
          value: OrderType.orderForSelf,
          label: Text('For myself'),
          icon: Icon(Icons.person_outline, size: 16),
        ),
        ButtonSegment(
          value: OrderType.orderForOthers,
          label: Text('For others'),
          icon: Icon(Icons.group_outlined, size: 16),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}
