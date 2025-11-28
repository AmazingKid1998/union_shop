import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/about_page.dart';
import '../pages/collections_page.dart';

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
        
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
          onPressed: () {},
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}