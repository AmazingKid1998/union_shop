import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/about_page.dart';
import '../pages/collections_page.dart';
import '../pages/cart_page.dart'; // <--- THIS WAS MISSING
import '../models/cart.dart';
import '../pages/login_page.dart';

class SiteHeader extends StatelessWidget implements PreferredSizeWidget {
  const SiteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'The UNION', 
        style: TextStyle(
          color: Colors.indigo, 
          fontWeight: FontWeight.bold, 
          fontSize: 24
        )
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Navigate to Home
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const HomePage())
            );
          }, 
          child: const Text('Home')
        ),
        TextButton(
          onPressed: () {
            // Navigate to About
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const AboutPage())
            );
          }, 
          child: const Text('About')
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const CollectionsPage())
            );
          }, 
          child: const Text('Shop')
        ),
        
        // Cart Icon with Badge
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
              onPressed: () {
                // Navigate and wait for result (so we refresh when coming back)
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const CartPage())
                ).then((_) => (context as Element).markNeedsBuild()); 
              },
            ),
            // The Badge
            if (globalCart.isNotEmpty)
              Positioned(
                right: 5,
                top: 5,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '${globalCart.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
          ],
        ),
        const SizedBox(width: 20),
        // Login Icon
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.black),
          onPressed: () {
             Navigator.push(
               context, 
               MaterialPageRoute(builder: (context) => const LoginPage())
             );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}