import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/about_page.dart';
import '../pages/collections_page.dart';
import '../pages/print_shack_page.dart';
import '../pages/collection_detail_page.dart';
import '../models/cart.dart'; // To show cart count
import '../pages/cart_page.dart';
import '../pages/login_page.dart';

class MobileNavMenu extends StatefulWidget {
  const MobileNavMenu({super.key});

  @override
  State<MobileNavMenu> createState() => _MobileNavMenuState();
}

class _MobileNavMenuState extends State<MobileNavMenu> {
  // Track which "screen" of the menu is visible
  // 0 = Main Menu, 1 = Shop Menu
  int _menuIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER SECTION ---
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black12)),
              ),
              child: _menuIndex == 0 
                  ? _buildMainHeader(context) 
                  : _buildShopHeader(),
            ),

            // --- MENU CONTENT ---
            Expanded(
              child: _menuIndex == 0 
                  ? _buildMainMenu() 
                  : _buildShopMenu(),
            ),
          ],
        ),
      ),
    );
  }

  // HEADER: Main View (Logo + Icons + X)
  Widget _buildMainHeader(BuildContext context) {
    return Row(
      children: [
         RichText(
          text: const TextSpan(
            children: [
              TextSpan(text: 'The ', style: TextStyle(color: Color(0xFF4B0082), fontFamily: 'Cursive', fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
              TextSpan(text: 'UNION', style: TextStyle(color: Color(0xFF4B0082), fontFamily: 'Serif', fontSize: 28, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
        const Spacer(),
        IconButton(icon: const Icon(Icons.search, size: 26), onPressed: () {}),
        IconButton(icon: const Icon(Icons.person_outline, size: 26), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginPage()))),
        
        // Cart Icon
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(icon: const Icon(Icons.shopping_bag_outlined, size: 26), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const CartPage()))),
            if (globalCart.isNotEmpty)
              Positioned(
                right: 4, top: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Color(0xFF4B0082), shape: BoxShape.circle),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text('${globalCart.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
              ),
          ],
        ),
        // Close Button (X)
        IconButton(
          icon: const Icon(Icons.close, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  // HEADER: Shop View (Back Arrow + "Shop")
  Widget _buildShopHeader() {
    return Row(
      children: [
        // Divider on the right of the arrow
        Container(
          decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.black12))),
          child: IconButton(
            icon: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
            onPressed: () {
              setState(() {
                _menuIndex = 0; // Go back to Main
              });
            },
          ),
        ),
        const SizedBox(width: 15),
        const Text('Shop', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
      ],
    );
  }

  // CONTENT: Main Menu List
  Widget _buildMainMenu() {
    return ListView(
      children: [
        _buildMenuItem('Home', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const HomePage()))),
        _buildMenuItem('Shop', hasArrow: true, onTap: () {
          setState(() {
            _menuIndex = 1; // Go to Shop Menu
          });
        }),
        _buildMenuItem('The Print Shack', hasArrow: true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const PrintShackPage()))),
        _buildMenuItem('SALE!', onTap: () {}), 
        _buildMenuItem('About', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const AboutPage()))),
        _buildMenuItem('UPSU.net', isLast: true, onTap: () {}), 
      ],
    );
  }

  // CONTENT: Shop Menu List (UPDATED FOR NEW MODEL)
  Widget _buildShopMenu() {
    // Helper to navigate using just ID and Title
    void navTo(String id, String title) {
      Navigator.push(context, MaterialPageRoute(builder: (c) => CollectionDetailPage(
        collectionId: id, 
        title: title
      )));
    }

    return ListView(
      children: [
        _buildMenuItem('Clothing', onTap: () => navTo('c_clothing', 'Clothing')),
        _buildMenuItem('Merchandise', onTap: () => navTo('c_merch', 'Merchandise')),
        _buildMenuItem('Halloween 🎃', onTap: () => navTo('c_halloween', 'Halloween')),
        _buildMenuItem('Signature & Essential Range', onTap: () => navTo('c_signature', 'Signature Range')),
        _buildMenuItem('Portsmouth City Collection', onTap: () => navTo('c_city', 'Portsmouth City')),
        _buildMenuItem('Pride Collection 🏳️‍🌈', onTap: () => navTo('c_pride', 'Pride Collection')),
        _buildMenuItem('Graduation 🎓', isLast: true, onTap: () => navTo('c_grad', 'Graduation')),
      ],
    );
  }

  // HELPER: Builds a single row in the menu
  Widget _buildMenuItem(String text, {bool hasArrow = false, bool isLast = false, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          border: isLast ? null : const Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyle(fontSize: 16, color: Colors.blueGrey[700], fontWeight: FontWeight.w500)),
            if (hasArrow) const Icon(Icons.chevron_right, size: 20, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}