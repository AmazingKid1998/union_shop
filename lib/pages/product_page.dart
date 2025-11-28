import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';
import '../models/cart.dart';
import 'cart_page.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product Image
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[100],
              child: Image.network(product.image, fit: BoxFit.cover),
            ),
            
            const SizedBox(height: 20),

            // Details Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '£${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 22, color: Colors.indigo),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  
                  // Add to Cart Button (Visual only for now)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                         // 1. Add to the global list
                         globalCart.add(product);
                         
                         // 2. Immediately navigate to the Cart Page
                         // usage of .then(...) forces the Product Page to refresh when you eventually come back
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => const CartPage()),
                         ).then((_) => (context as Element).markNeedsBuild());
                      },
                      child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}