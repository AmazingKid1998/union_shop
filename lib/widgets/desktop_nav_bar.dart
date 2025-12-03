import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import 'product_search_delegate.dart';

class DesktopNavBar extends StatelessWidget {
  const DesktopNavBar({super.key});

  // Helper to build the main navigation links
  Widget _buildNavLink(BuildContext context, String text, String route) {
    return TextButton(
      onPressed: () {
        if (text == 'The Print Shack') {
          // Special case: Navigate to the Print Shack menu page
          Navigator.pushNamed(context, '/print-shack');
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: text == 'SALE!' ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access Cart VM only for the badge count
    final cartVM = Provider.of<CartViewModel>(context);
    final cartCount = cartVM.rawItems.length;

    return Container(
      height: kToolbarHeight, // Standard Flutter toolbar height
      padding: const EdgeInsets.symmetric(horizontal: 25),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. LOGO
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(text: 'The ', style: TextStyle(color: Color(0xFF4B0082), fontFamily: 'Cursive', fontSize: 28, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                  TextSpan(text: 'UNION', style: TextStyle(color: Color(0xFF4B0082), fontFamily: 'Serif', fontSize: 32, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 40),

          // 2. NAVIGATION LINKS (CENTERED)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNavLink(context, 'Home', '/'),
              _buildNavLink(context, 'Shop', '/shop'),
              _buildNavLink(context, 'The Print Shack', '/print-shack'),
              _buildNavLink(context, 'SALE!', '/sale'),
              _buildNavLink(context, 'About', '/about'),
            ],
          ),

          const Spacer(),

          // 3. ICONS (RIGHT ALIGNED)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search Icon
              IconButton(
                icon: const Icon(Icons.search, size: 26, color: Colors.black87),
                onPressed: () {
                  showSearch(context: context, delegate: ProductSearchDelegate());
                },
              ),
              // Profile Icon
              IconButton(
                icon: const Icon(Icons.person_outline, size: 26, color: Colors.black87),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
              // Cart Icon
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined, size: 26, color: Colors.black87),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart').then((_) => (context as Element).markNeedsBuild());
                    },
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: 4, top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Color(0xFF4B0082), shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}