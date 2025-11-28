import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/about_page.dart';
import '../pages/collections_page.dart';
import '../pages/print_shack_page.dart';
import '../pages/cart_page.dart';
import '../pages/login_page.dart';
import '../models/cart.dart';

class SiteHeader extends StatelessWidget implements PreferredSizeWidget {
  const SiteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. THE PURPLE BANNER
        Container(
          width: double.infinity,
          color: const Color(0xFF4B0082), // Deep Indigo
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: const Text(
            'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),

        // 2. THE NAVBAR (Logo + Icons)
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
            ],
          ),
          child: Row(
            children: [
              // LOGO: "The UNION"
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'The ',
                      style: TextStyle(
                        color: Color(0xFF4B0082),
                        fontFamily: 'Cursive', // Tries to look hand-written
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextSpan(
                      text: 'UNION',
                      style: TextStyle(
                        color: Color(0xFF4B0082),
                        fontFamily: 'Serif', // Looks blocky like the image
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),

              // SEARCH ICON
              IconButton(
                icon: const Icon(Icons.search, size: 26, color: Colors.black87),
                onPressed: () {}, // Dummy action
              ),

              // PROFILE ICON
              IconButton(
                icon: const Icon(Icons.person_outline, size: 26, color: Colors.black87),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                },
              ),

              // CART ICON WITH BADGE
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined, size: 26, color: Colors.black87),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()))
                          .then((_) => (context as Element).markNeedsBuild());
                    },
                  ),
                  if (globalCart.isNotEmpty)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Color(0xFF4B0082), shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text(
                          '${globalCart.length}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),

              // HAMBURGER MENU (Contains the links)
              PopupMenuButton<String>(
                icon: const Icon(Icons.menu, size: 30, color: Colors.black87),
                onSelected: (value) {
                  // Handle navigation
                  if (value == 'home') {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                  } else if (value == 'shop') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CollectionsPage()));
                  } else if (value == 'print') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PrintShackPage()));
                  } else if (value == 'about') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()));
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(value: 'home', child: Text('Home')),
                  const PopupMenuItem<String>(value: 'shop', child: Text('Shop')),
                  const PopupMenuItem<String>(value: 'print', child: Text('The Print Shack', style: TextStyle(color: Colors.pink))),
                  const PopupMenuItem<String>(value: 'about', child: Text('About')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Adjusted height to fit the banner + navbar
  @override
  Size get preferredSize => const Size.fromHeight(110);
}