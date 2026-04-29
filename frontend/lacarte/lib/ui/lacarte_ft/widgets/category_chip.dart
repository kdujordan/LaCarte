import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final bool isSelected;

  final String? iconPath;

  final String label;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFCADBB7) : Color(0xffffffff),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.tertiary,
        ),
      ),
      child: Row(
        children: [
          if (iconPath != null) ...[
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(iconPath!),
              // child: Image.network(iconPath!, fit: BoxFit.cover),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.black54,
            ),
          ),
        ],
      ),
    );
    // return const Placeholder();
  }
}
