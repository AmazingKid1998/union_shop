import 'package:flutter/material.dart';
import '../data/dummy_data.dart'; // Import data
import '../models/product.dart';  // Import model
import 'product_page.dart';       
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';
import '../widgets/home_carousel.dart'; // Import the new carousel

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. CAROUSEL SECTION (Replaces the old static banner)
            const HomeCarousel(),
            
            const SizedBox(height: 40),

            // 2. Featured Section
            const Text('Essential Range', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 20),
            
            // Generate widgets from our dummy data list
            Wrap(
              spacing: 20,
              runSpacing: 20,
              // Show just the first 4 items for the homepage
              children: dummyProducts.take(4).map((product) {
                return _buildProductItem(context, product);
              }).toList(),
            ),

            const SizedBox(height: 40),

            // 3. Footer
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  // A helper to build a clickable product card
  Widget _buildProductItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(product: product),
          ),
        );
      },
      child: Container(
        width: 150,
        // Removed border to look cleaner
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.asset(product.image, fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),
            Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('£${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}