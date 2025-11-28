import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/dummy_data.dart';
import 'product_page.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

class CollectionDetailPage extends StatelessWidget {
  final String collectionId;
  final String title;

  const CollectionDetailPage({
    super.key, 
    required this.collectionId, 
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    // Filter using the new attribute
    final products = getProductsByCollection(collectionId);

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            
            if (products.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Text('No products found in this collection.', style: TextStyle(color: Colors.grey)),
              )
            else
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
                                  Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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