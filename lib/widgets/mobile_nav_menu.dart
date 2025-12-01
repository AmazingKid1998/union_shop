import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../pages/collection_detail_page.dart'; 

class MobileNavMenu extends StatefulWidget {
  const MobileNavMenu({super.key});

  @override
  State<MobileNavMenu> createState() => _MobileNavMenuState();
}

class _MobileNavMenuState extends State<MobileNavMenu> {
  // 0 = Main, 1 = Shop, 2 = Print Shack
  int _menuIndex = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black12)),
              ),
              child: _buildHeader(),
            ),

            // --- MENU CONTENT ---
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // 1. MAIN HEADER
    if (_menuIndex == 0) {
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
          IconButton(icon: const Icon(Icons.person_outline, size: 26), onPressed: () => Navigator.pushNamed(context, '/login')),
          Consumer<CartViewModel>(
            builder: (context, cartVM, child) {
              final cartCount = cartVM.rawItems.length;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(icon: const Icon(Icons.shopping_bag_outlined, size: 26), onPressed: () => Navigator.pushNamed(context, '/cart')),
                  if (cartCount > 0)
                    Positioned(right: 4, top: 4, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Color(0xFF4B0082), shape: BoxShape.circle), constraints: const BoxConstraints(minWidth: 18, minHeight: 18), child: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center))),
                ],
              );
            }
          ),
          IconButton(icon: const Icon(Icons.close, size: 30), onPressed: () => Navigator.pop(context)),
        ],
      );
    }
    
    // 2. SUBMENU HEADER (Used for Shop OR Print Shack)
    String title = _menuIndex == 1 ? 'Shop' : 'The Print Shack';
    return Row(
      children: [
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
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
      ],
    );
  }

  Widget _buildBody() {
    if (_menuIndex == 1) return _buildShopMenu();
    if (_menuIndex == 2) return _buildPrintShackMenu();
    return _buildMainMenu();
  }

  // --- 1. MAIN MENU ---
  Widget _buildMainMenu() {
    return ListView(
      children: [
        _buildMenuItem('Home', onTap: () => Navigator.pushNamed(context, '/')),
        _buildMenuItem('Shop', hasArrow: true, onTap: () => setState(() => _menuIndex = 1)),
        _buildMenuItem('The Print Shack', hasArrow: true, onTap: () => setState(() => _menuIndex = 2)), // Opens sub menu
        _buildMenuItem('SALE!', onTap: () => Navigator.pushNamed(context, '/sale')), 
        _buildMenuItem('About', onTap: () => Navigator.pushNamed(context, '/about')),
        _buildMenuItem('UPSU.net', isLast: true, onTap: () {}), 
      ],
    );
  }

  // --- 2. SHOP SUBMENU ---
  Widget _buildShopMenu() {
    void navTo(String id, String title) {
      Navigator.push(context, MaterialPageRoute(builder: (c) => CollectionDetailPage(collectionId: id, title: title)));
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

  // --- 3. PRINT SHACK SUBMENU (MATCHES YOUR SCREENSHOT) ---
  Widget _buildPrintShackMenu() {
    return ListView(
      children: [
        _buildMenuItem('About', onTap: () => Navigator.pushNamed(context, '/print-shack/about')),
        _buildMenuItem('Personalisation', isLast: true, onTap: () => Navigator.pushNamed(context, '/print-shack/tool')),
      ],
    );
  }

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