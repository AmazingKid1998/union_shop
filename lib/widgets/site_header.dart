import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <--- ADDED THIS IMPORT
import '../viewmodels/cart_viewmodel.dart'; // <--- ADDED THIS IMPORT
import 'mobile_nav_menu.dart'; 
import 'desktop_nav_bar.dart'; // Import new desktop widget

class SiteHeader extends StatelessWidget implements PreferredSizeWidget {
  // Define a constant breakpoint for responsiveness
  static const double desktopBreakpoint = 800;

  const SiteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If the screen width is greater than the breakpoint, show the desktop view.
        if (constraints.maxWidth > desktopBreakpoint) {
          return const DesktopNavBarWrapper();
        } else {
          // Otherwise, show the mobile view (which includes the purple banner and hamburger icon).
          return const MobileNavBarWrapper();
        }
      },
    );
  }

  @override
  Size get preferredSize {
    // The total height of the header needs to be consistent.
    // Mobile: Banner (~50px) + Navbar (60px) = 110px
    // Desktop: Just Navbar (60px)
    return const Size.fromHeight(kToolbarHeight + 50); // Defaulting to mobile height for consistency
  }
}

// Helper wrapper for Mobile (includes the purple banner)
class MobileNavBarWrapper extends StatelessWidget implements PreferredSizeWidget {
  const MobileNavBarWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Mobile view includes the purple banner and the mobile/hamburger nav row.
    return Column(
      children: [
        // The Purple Banner
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
        // The Mobile/Hamburger Nav Bar (from the previous implementation)
        const MobileNavRow(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 50);
}

// Extracted the Mobile Nav Row logic from the old SiteHeader
class MobileNavRow extends StatelessWidget {
  const MobileNavRow({super.key});

  @override
  Widget build(BuildContext context) {
    // We rebuild the Mobile header row logic here
    return Container(
      height: kToolbarHeight, // Fixed height for the nav row
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          // Logo
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(text: 'The ', style: TextStyle(color: Color(0xFF4B0082), fontFamily: 'Cursive', fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                  TextSpan(text: 'UNION', style: TextStyle(color: Color(0xFF4B0082), fontFamily: 'Serif', fontSize: 28, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
          
          const Spacer(),

          // Icons
          // ... (Icons logic remains the same, but extracted for clarity)
          
          // SEARCH ICON
          IconButton(
            icon: const Icon(Icons.search, size: 26, color: Colors.black87),
            onPressed: () { /* Search logic */ }, 
          ),

          // PROFILE ICON
          IconButton(
            icon: const Icon(Icons.person_outline, size: 26, color: Colors.black87),
            onPressed: () { Navigator.pushNamed(context, '/login'); },
          ),

          // CART ICON WITH BADGE (Consumer is now defined because provider is imported)
          Consumer<CartViewModel>(
            builder: (context, cartVM, child) {
              final cartCount = cartVM.rawItems.length;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined, size: 26, color: Colors.black87),
                    onPressed: () { Navigator.pushNamed(context, '/cart').then((_) => (context as Element).markNeedsBuild()); },
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
              );
            }
          ),

          // HAMBURGER MENU (Opens the slide-out menu)
          IconButton(
            icon: const Icon(Icons.menu, size: 30, color: Colors.black87),
            onPressed: () {
              Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const MobileNavMenu(), transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0); const end = Offset.zero; const curve = Curves.ease; var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve)); return SlideTransition(position: animation.drive(tween), child: child);
              }));
            },
          ),
        ],
      ),
    );
  }
}

// Wrapper for Desktop (ensures we define PreferredSize)
class DesktopNavBarWrapper extends StatelessWidget implements PreferredSizeWidget {
  const DesktopNavBarWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Desktop view shows only the clean horizontal bar
    return const DesktopNavBar();
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Only the height of the nav bar itself
}