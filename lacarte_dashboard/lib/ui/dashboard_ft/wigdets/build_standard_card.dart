import 'package:flutter/material.dart';

class BuildStandardCard extends StatelessWidget {
  final String id;
  final String type;
  final String time;
  final List<String> items;
  final String price;
  final String btnText;
  final bool isBtnPrimary;
  final Color? buttonColor;

  const BuildStandardCard({
    required this.id,
    required this.type,
    required this.time,
    required this.items,
    required this.price,
    required this.btnText,
    required this.isBtnPrimary,
    this.buttonColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    id,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F2EE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2EFE9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF728A7C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                '• $item',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBtnPrimary
                      ? (buttonColor ?? const Color(0xFF1E231F))
                      : const Color(0xFFF4F2EE),
                  foregroundColor: isBtnPrimary ? Colors.white : Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  minimumSize: Size.zero,
                  elevation: 0,
                ),
                child: Row(
                  children: [
                    if (btnText == 'Dispatch')
                      const Padding(
                        padding: EdgeInsets.only(right: 4.0),
                        child: Icon(Icons.local_shipping_outlined, size: 14),
                      ),
                    Text(
                      btnText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
