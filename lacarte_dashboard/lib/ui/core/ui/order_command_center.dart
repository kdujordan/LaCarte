import 'package:flutter/material.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/wigdets/build_column.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/wigdets/build_delivery_column.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/wigdets/build_standard_card.dart';

class OrderCommandCenter extends StatelessWidget {
  const OrderCommandCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 32.0,
        right: 32.0,
        bottom: 32.0,
        left: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Command Center',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E231F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Live feed and status tracking for all active orders.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search orders, items...',
                        hintStyle: const TextStyle(fontSize: 13),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.notifications_none,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=11',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Kanban Board Columns
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildColumn(
                  title: 'New',
                  count: '3',
                  dotColor: const Color(0xFF3B5998), // Dark Blue
                  cards: [
                    BuildStandardCard(
                      id: '#412',
                      type: 'Dine-in',
                      time: '2m',
                      items: ['2x Truffle Risotto', '1x Wine Pairing'],
                      price: '\$72.00',
                      btnText: 'Accept',
                      isBtnPrimary: true,
                    ),
                    BuildStandardCard(
                      id: '#413',
                      type: 'Delivery',
                      time: '4m',
                      items: ['1x Seared Scallops', '1x Sparkling Water'],
                      price: '\$38.00',
                      btnText: 'Accept',
                      isBtnPrimary: true,
                    ),
                    BuildStandardCard(
                      id: '#414',
                      type: 'Pickup',
                      time: '5m',
                      items: ['2x Heirloom Burrata'],
                      price: '\$37.00',
                      btnText: 'Accept',
                      isBtnPrimary: true,
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                BuildColumn(
                  title: 'Preparing',
                  count: '2',
                  dotColor: const Color(0xFF728A7C), // Sage green
                  cards: [
                    BuildStandardCard(
                      id: '#410',
                      type: 'Dine-in',
                      time: '12m',
                      items: ['1x Filet Mignon (Med Rare)', '2x Truffle Fries'],
                      price: '\$85.00',
                      btnText: 'Mark Ready',
                      isBtnPrimary: false,
                    ),
                    BuildStandardCard(
                      id: '#411',
                      type: 'Delivery',
                      time: '8m',
                      items: ['1x Steak', '2x House Salad'],
                      price: '\$45.00',
                      btnText: 'Mark Ready',
                      isBtnPrimary: false,
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                BuildColumn(
                  title: 'Ready',
                  count: '1',
                  dotColor: const Color(0xFF728A7C),
                  cards: [
                    BuildStandardCard(
                      id: '#408',
                      type: 'Delivery',
                      time: '18m',
                      items: ['3x Carbonara Pasta', '1x Tomato Soup'],
                      price: '\$92.00',
                      btnText: 'Dispatch',
                      isBtnPrimary: true,
                      buttonColor: const Color(0xFF2E453A),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Out for Delivery Column (Distinct Dark Styling)
                BuildDeliveryColumn(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Generic column builder for the white background columns
}
