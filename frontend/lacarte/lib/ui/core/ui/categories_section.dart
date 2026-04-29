import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/category_chip.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/food_carousel_card.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  final List<Map<String, dynamic>> categories = [
    {"name": "All", "icon": null},
    {
      "name": "Pizza",
      "icon":
          "https://images.pexels.com/photos/35017345/pexels-photo-35017345.jpeg",
    },
    {
      "name": "Pasta",
      "icon":
          "https://images.pexels.com/photos/29653125/pexels-photo-29653125.jpeg",
    },
    {
      "name": "Noodles",
      "icon":
          "https://images.pexels.com/photos/4223946/pexels-photo-4223946.jpeg",
    },
    {
      "name": "Burgers",
      "icon":
          "https://images.pexels.com/photos/5554607/pexels-photo-5554607.jpeg",
    },
    {
      "name": "Salads",
      "icon":
          "https://images.pexels.com/photos/406152/pexels-photo-406152.jpeg",
    },
    {
      "name": "Desserts",
      "icon":
          "https://images.pexels.com/photos/1126359/pexels-photo-1126359.jpeg",
    },
    {
      "name": "Drinks",
      "icon":
          "https://images.pexels.com/photos/605408/pexels-photo-605408.jpeg",
    },
  ];

  int _selectedCategoryIndex = 0;

  final ItemScrollController _itemScrollController = ItemScrollController();

  final List<Map<String, dynamic>> foodItems = [
    {
      "name": "Margherita Basil",
      "category": "Pizza",
      "price": 12.99,
      "image":
          "https://images.pexels.com/photos/1146760/pexels-photo-1146760.jpeg",
      "description": "Fresh mozzarella, tomato sauce, and organic basil.",
    },
    {
      "name": "Creamy Fettuccine",
      "category": "Pasta",
      "price": 15.50,
      "image":
          "https://images.pexels.com/photos/1437267/pexels-photo-1437267.jpeg",
      "description": "Homemade pasta with garlic parmesan cream sauce.",
    },
    {
      "name": "Spicy Miso Ramen",
      "category": "Noodles",
      "price": 14.00,
      "image":
          "https://images.pexels.com/photos/1907228/pexels-photo-1907228.jpeg",
      "description": "Rich broth with bamboo shoots and soft-boiled egg.",
    },
    {
      "name": "Truffle Beef Burger",
      "category": "Burgers",
      "price": 18.00,
      "image":
          "https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg",
      "description": "Wagyu beef patty with truffle aioli and brioche bun.",
    },
    {
      "name": "Pesto Penne",
      "category": "Pasta",
      "price": 13.50,
      "image":
          "https://images.pexels.com/photos/1273765/pexels-photo-1273765.jpeg",
      "description": "Fresh basil pesto with toasted pine nuts.",
    },
    {
      "name": "Double Cheese Smash",
      "category": "Burgers",
      "price": 16.00,
      "image":
          "https://images.pexels.com/photos/1199957/pexels-photo-1199957.jpeg",
      "description": "Two smashed patties with sharp cheddar and pickles.",
    },
    // --- New Items ---
    {
      "name": "Greek Quinoa Salad",
      "category": "Salads",
      "price": 11.00,
      "image":
          "https://images.pexels.com/photos/1213710/pexels-photo-1213710.jpeg",
      "description":
          "Crisp cucumbers, olives, and feta with lemon vinaigrette.",
    },
    {
      "name": "Pepperoni Feast",
      "category": "Pizza",
      "price": 14.50,
      "image":
          "https://images.pexels.com/photos/825661/pexels-photo-825661.jpeg",
      "description": "Double layer of spicy pepperoni and extra cheese.",
    },
    {
      "name": "Pad Thai Shrimp",
      "category": "Noodles",
      "price": 16.50,
      "image":
          "https://images.pexels.com/photos/5848496/pexels-photo-5848496.jpeg",
      "description": "Stir-fried rice noodles with tamarind sauce and peanuts.",
    },
    {
      "name": "Lava Chocolate Cake",
      "category": "Desserts",
      "price": 8.50,
      "image":
          "https://images.pexels.com/photos/45202/brownie-dessert-cake-sweet-45202.jpeg",
      "description":
          "Warm chocolate cake with a molten center and vanilla ice cream.",
    },
    {
      "name": "Berry Blast Smoothie",
      "category": "Drinks",
      "price": 6.99,
      "image":
          "https://images.pexels.com/photos/103566/pexels-photo-103566.jpeg",
      "description": "Blended blueberries, strawberries, and Greek yogurt.",
    },
    {
      "name": "Classic Tiramisu",
      "category": "Desserts",
      "price": 9.00,
      "image":
          "https://images.pexels.com/photos/6880219/pexels-photo-6880219.jpeg",
      "description": "Coffee-soaked ladyfingers with mascarpone cream.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: true,
            floating: true,
            actionsIconTheme: IconThemeData(color: Colors.black),
            title: Text(
              "Categories",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            expandedHeight: 130,
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Column(
                children: [
                  Divider(height: 1, color: Colors.grey[200]),

                  SizedBox(height: 10),

                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        // vertical: 10,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });

                            _itemScrollController.scrollTo(
                              index: index,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: CategoryChip(
                            label: categories[index]["name"],
                            isSelected: _selectedCategoryIndex == index,
                            iconPath: categories[index]["icon"],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(height: 1, color: Colors.grey[300]),
                ],
              ),
            ),
          ),

          SliverFillRemaining(
            child: ScrollablePositionedList.builder(
              itemCount: categories.length,
              itemScrollController: _itemScrollController,
              itemBuilder: (context, index) {
                final String categoryName = categories[index]["name"];
                final List<Map<String, dynamic>> filteredItems =
                    categoryName == "All"
                    ? foodItems
                    : foodItems
                          .where((item) => item["category"] == categoryName)
                          .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Text(
                        categoryName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Placeholder for category items
                    if (filteredItems.isNotEmpty)
                      CarouselSlider.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, itemIndex, pageViewIndex) {
                          return FoodCarouselCard(
                            item: filteredItems[itemIndex],
                          );
                        },
                        options: CarouselOptions(
                          height: 420.0,
                          viewportFraction: 0.75,
                          enableInfiniteScroll: false,
                          padEnds: true,
                          enlargeCenterPage: true,
                          // disableCenter: true,
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "No items available in this category.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),

                    const SizedBox(height: 40),

                    if (index == categories.length - 1)
                      const SizedBox(height: 400),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
