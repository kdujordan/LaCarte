import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lacarte/ui/core/ui/categories_section.dart';
import 'package:lacarte/ui/lacarte_ft/view_models/menu_view_model.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/category_chip.dart';
import 'package:lacarte/ui/lacarte_ft/widgets/food_carousel_card.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final List<Map<String, dynamic>> categories = [
  //   {"name": "All", "icon": null},
  //   {
  //     "name": "Pizza",
  //     "icon":
  //         "https://images.pexels.com/photos/35017345/pexels-photo-35017345.jpeg",
  //   },
  //   {
  //     "name": "Pasta",
  //     "icon":
  //         "https://images.pexels.com/photos/29653125/pexels-photo-29653125.jpeg",
  //   },
  //   {
  //     "name": "Noodles",
  //     "icon":
  //         "https://images.pexels.com/photos/4223946/pexels-photo-4223946.jpeg",
  //   },
  //   {
  //     "name": "Burgers",
  //     "icon":
  //         "https://images.pexels.com/photos/5554607/pexels-photo-5554607.jpeg",
  //   },
  // ];

  int _selectedCategoryIndex = 0;

  final ItemScrollController _itemScrollController = ItemScrollController();

  // final List<Map<String, dynamic>> foodItems = [
  //   {
  //     "name": "Margherita Basil",
  //     "category": "Pizza",
  //     "price": 12.99,
  //     "image":
  //         "https://images.pexels.com/photos/1146760/pexels-photo-1146760.jpeg",
  //     "description": "Fresh mozzarella, tomato sauce, and organic basil.",
  //   },
  //   {
  //     "name": "Creamy Fettuccine",
  //     "category": "Pasta",
  //     "price": 15.50,
  //     "image":
  //         "https://images.pexels.com/photos/1437267/pexels-photo-1437267.jpeg",
  //     "description": "Homemade pasta with garlic parmesan cream sauce.",
  //   },
  //   {
  //     "name": "Spicy Miso Ramen",
  //     "category": "Noodles",
  //     "price": 14.00,
  //     "image":
  //         "https://images.pexels.com/photos/1907228/pexels-photo-1907228.jpeg",
  //     "description": "Rich broth with bamboo shoots and soft-boiled egg.",
  //   },
  //   {
  //     "name": "Truffle Beef Burger",
  //     "category": "Burgers",
  //     "price": 18.00,
  //     "image":
  //         "https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg",
  //     "description": "Wagyu beef patty with truffle aioli and brioche bun.",
  //   },
  //   {
  //     "name": "Pesto Penne",
  //     "category": "Pasta",
  //     "price": 13.50,
  //     "image":
  //         "https://images.pexels.com/photos/1273765/pexels-photo-1273765.jpeg",
  //     "description": "Fresh basil pesto with toasted pine nuts.",
  //   },
  //   {
  //     "name": "Double Cheese Smash",
  //     "category": "Burgers",
  //     "price": 16.00,
  //     "image":
  //         "https://images.pexels.com/photos/1199957/pexels-photo-1199957.jpeg",
  //     "description": "Two smashed patties with sharp cheddar and pickles.",
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    // final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final menuViewModel = context.watch<MenuViewModel>();

    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            stretch: true,
            floating: true,
            stretchTriggerOffset: 300.0,
            expandedHeight: 250,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
            title: Text("Berries", style: GoogleFonts.boldonse()),
            // bottom: ,
            flexibleSpace: FlexibleSpaceBar(
              // title: Text(
              //   "La~Carte",
              //   style: TextStyle(
              //     color: Theme.of(context).colorScheme.onSurface,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              background: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          "https://images.pexels.com/photos/31300955/pexels-photo-31300955.jpeg",
                          fit: BoxFit.cover,
                        ),

                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Color(0xFF485935)],
                              stops: [0.1, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 0, // Pins the widget to the bottom
                    left: 0, // Pins to the left edge
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const FlutterLogo(size: 40),
                          Text(
                            "Eat Healthy",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.w200,
                            ),
                            textAlign: TextAlign.start,
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "Live Healthy",
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 10),

                          // Container(
                          //   height: 45,
                          //   decoration: BoxDecoration(
                          //     color: Theme.of(context).colorScheme.tertiary,
                          //     border: Border.all(),
                          //     borderRadius: BorderRadius.circular(25),
                          //   ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: TextField(
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                              cursorColor: Colors.white70,
                              decoration: InputDecoration(
                                // fillColor: Theme.of(context).colorScheme.primary,
                                hintText: "Search...",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) => const CategoriesSection(),
                            ),
                          );
                        },
                        child: const Text(
                          'See all',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child:
                      menuViewModel.categories.isEmpty &&
                          menuViewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: menuViewModel.categories.length,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategoryIndex = index;
                                });

                                // _itemScrollController.scrollTo(
                                //   index: index,
                                //   duration: Duration(milliseconds: 500),
                                //   curve: Curves.easeInOut,
                                // );
                              },
                              child: CategoryChip(
                                label:
                                    menuViewModel.categories[index]["name"] ??
                                    'Unknown',
                                isSelected: _selectedCategoryIndex == index,
                                iconPath: menuViewModel
                                    .categories[index]["icon_name"],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            child: menuViewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ScrollablePositionedList.builder(
                    itemCount: menuViewModel.categories.length,
                    itemScrollController: _itemScrollController,
                    itemBuilder: (context, index) {
                      final String categoryName =
                          menuViewModel.categories[index]["name"] ?? "Unknown";
                      final List<dynamic> filteredItems = categoryName == "All"
                          ? menuViewModel.allMenuItems
                          : menuViewModel.allMenuItems
                                .where(
                                  (item) =>
                                      (item["category_name"] ?? "") ==
                                      categoryName,
                                )
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
                                padEnds: false,
                                disableCenter: true,
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

                          if (index == menuViewModel.categories.length - 1)
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
