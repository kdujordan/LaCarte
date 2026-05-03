import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;
  final bool active;
  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? color : Colors.transparent,
          width: active ? 1.5 : 0,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          color: color,
        ),
      ),
    );
  }
}
