import 'package:flutter/material.dart';
import 'package:lacarte/ui/core/ui/menu_item_details_page.dart';

class FoodCarouselCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const FoodCarouselCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final String heroTag = 'item_${item['id'] ?? item['name']}';
    return GestureDetector(
      onTap: () {
        // 2. Navigate to details when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuItemDetailsPage(item: item),
          ),
        );
      },
      child: Container(
        width: 350, // Width of the card
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          // image: DecorationImage(
          //   image: NetworkImage(
          //     item['image_url'] ?? 'https://via.placeholder.com/280',
          //   ),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: Stack(
            children: [
              Positioned.fill(
                child: Hero(
                  tag: heroTag, // THE KEY TO THE ANIMATION
                  child: Image.network(
                    item['image_url'] ?? 'https://via.placeholder.com/280',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // 1. Bottom Gradient for text readability
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(35),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Top Right Discount Badge
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "20% off",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),

              // 3. Bottom Content (Text, Tags, Button)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Price Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['name'] ?? 'Unknown Item',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "UGX ${_parsePrice(item['price']).toInt()}", // Adapted for your local currency
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      item['description'] ?? 'No description available',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Tags (Best Seller, etc.)
                    Row(
                      children: [
                        _buildTag("Best Seller"),
                        const SizedBox(width: 8),
                        _buildTag("9 left"),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MenuItemDetailsPage(item: item),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "Add to cart",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to safely parse price from various types
  double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      try {
        return double.parse(price);
      } catch (e) {
        return 0.0;
      }
    }
    try {
      return (price as num).toDouble();
    } catch (e) {
      return 0.0;
    }
  }

  // Helper widget for the small tags
  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }
}
