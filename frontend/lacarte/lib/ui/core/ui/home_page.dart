import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            stretch: true,
            stretchTriggerOffset: 300.0,
            expandedHeight: 250,
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
            title: Text("Berries", style: GoogleFonts.boldonse()),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(150.0),
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
                      style: TextStyle(fontSize: 30.0, color: Colors.white),
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
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        cursorColor: Colors.white70,
                        decoration: InputDecoration(
                          // fillColor: Theme.of(context).colorScheme.primary,
                          hintText: "Search...",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    // ),
                  ],
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              // title: Text(
              //   "La~Carte",
              //   style: TextStyle(
              //     color: Theme.of(context).colorScheme.onSurface,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              background: ClipRRect(
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
            ),
          ),
        ],
      ),
    );
  }
}
