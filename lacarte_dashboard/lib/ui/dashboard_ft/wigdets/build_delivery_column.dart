import 'package:flutter/material.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/wigdets/build_delivery_card.dart';

class BuildDeliveryColumn extends StatelessWidget {
  const BuildDeliveryColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A4B3A), // Dark elegant green
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Out for Delivery',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '2',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                BuildDeliveryCard(
                  id: '#405',
                  distance: '4m away',
                  items: ['2x Sushi Boat'],
                  customer: 'Alex M.',
                ),
                BuildDeliveryCard(
                  id: '#406',
                  distance: '12m away',
                  items: ['1x Vegan Bowl', '1x Green Juice'],
                  customer: 'Sarah K.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
