import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import 'mobile_nav_menu.dart'; 
import 'product_search_delegate.dart'; 

class SiteHeader extends StatelessWidget implements PreferredSizeWidget {
  const SiteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. THE PURPLE BANNER
        Container(
          width: double.infinity,
          color: const Color(0xFF4B0082),
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
              // LOGO
              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/'),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'The ',
                        style: TextStyle(color: Color(0xFF4B0082), fontFamily: 'Cursive', fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                      ),
                      TextSpan(
                        text: 'UNION',
                        style: TextStyle(color: Color(0xFF4B0082), fontFamily: 'Serif', fontSize: 28, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),

              // SEARCH ICON
              IconButton(
                icon: const Icon(Icons.search, size: 26, color: Colors.black87),
                onPressed: () {
                  showSearch(context: context, delegate: ProductSearchDelegate());
                }, 
              ),

              // PROFILE ICON
              IconButton(
                icon: const Icon(Icons.person_outline, size: 26, color: Colors.black87),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),

              // CART ICON WITH BADGE (USING CONSUMER FOR LIVE UPDATE)
              Consumer<CartViewModel>(
                builder: (context, cartVM, child) {
                  final cartCount = cartVM.rawItems.length;
                  
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined, size: 26, color: Colors.black87),
                        onPressed: () {
                          // Navigate to Cart Page and request a refresh on return
                          Navigator.pushNamed(context, '/cart')
                              .then((_) => (context as Element).markNeedsBuild());
                        },
                      ),
                      if (cartCount > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Color(0xFF4B0082), shape: BoxShape.circle),
                            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                            child: Text(
                              '$cartCount', // Uses ViewModel count
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                }
              ),

              // HAMBURGER MENU
              IconButton(
                icon: const Icon(Icons.menu, size: 30, color: Colors.black87),
                onPressed: () {
                  Navigator.push(
                    context, 
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const MobileNavMenu(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;
                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        return SlideTransition(position: animation.drive(tween), child: child);
                      },
                    )
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110);
}