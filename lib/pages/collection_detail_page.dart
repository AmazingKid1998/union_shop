import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/dummy_data.dart';
import 'product_page.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

class CollectionDetailPage extends StatelessWidget {
  final Collection collection;

  const CollectionDetailPage({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    // Get products for this specific collection
    final products = getProductsByCollection(collection.id);

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(collection.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            
            // Product Grid
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: products.map((product) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductPage(product: product)),
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
                          SizedBox(
                            height: 120,
                            width: double.infinity,
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
                }).toList(),
              ),
            ),
            const SizedBox(height: 40),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}