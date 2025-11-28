import 'package:flutter/material.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(), // The Navbar
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Hero Section (Big Image)
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.indigo, // Placeholder for image
              alignment: Alignment.center,
              child: const Text(
                'BIG SALE! 20% OFF!', 
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 40),

            // 2. Featured Section
            const Text('Essential Range', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 20),
            
            // Placeholder for products (We will make this dynamic in Phase 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDummyProduct('Hoodie'),
                _buildDummyProduct('T-Shirt'),
                _buildDummyProduct('Mug'),
              ],
            ),

            const SizedBox(height: 40),

            // 3. The Footer
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  // A quick helper widget just for this page to show boxes
  Widget _buildDummyProduct(String name) {
    return Container(
      height: 150,
      width: 100,
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: Text(name),
    );
  }
}