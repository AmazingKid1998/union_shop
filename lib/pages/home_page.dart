import 'package:flutter/material.dart';
import '../data/dummy_data.dart'; // Import data
import '../models/product.dart';  // Import model
import 'product_page.dart';       // Import the new page
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Hero Section
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.indigo,
              alignment: Alignment.center,
              child: const Text(
                'BIG SALE! 20% OFF!', 
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 40),

            // 2. Featured Section (Now Dynamic!)
            const Text('Essential Range', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 20),
            
            // Generate widgets from our dummy data list
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: dummyProducts.map((product) {
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
        // Navigate to the Product Details Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(product: product),
          ),
        );
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            // Image
            Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.network(product.image, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('£${product.price}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}