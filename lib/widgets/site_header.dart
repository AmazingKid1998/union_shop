import 'package:flutter/material.dart';

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
        // Dummy links for now
        TextButton(onPressed: () {}, child: const Text('Home')),
        TextButton(onPressed: () {}, child: const Text('Shop')),
        TextButton(onPressed: () {}, child: const Text('About')),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
          onPressed: () {},
        ),
        const SizedBox(width: 20), // Spacing
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}