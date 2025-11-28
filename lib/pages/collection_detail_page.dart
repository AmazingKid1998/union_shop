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
    // 1. Get the products for this collection
    final products = getProductsByCollection(collectionId);

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ),
            ),
            
            // 2. The Product Grid
            if (products.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Text('No products found.', style: TextStyle(color: Colors.grey)),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: GridView.builder(
                  shrinkWrap: true, // Important because we are inside a ScrollView
                  physics: const NeverScrollableScrollPhysics(), // Let the main page scroll
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 Columns
                    crossAxisSpacing: 20, // Horizontal space between items
                    mainAxisSpacing: 30, // Vertical space between items
                    childAspectRatio: 0.70, // Adjusts height (lower number = taller card)
                  ),
                  itemBuilder: (context, index) {
                    return _buildProductItem(context, products[index]);
                  },
                ),
              ),

            const SizedBox(height: 60),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  // 3. The Individual Product Card Design
  Widget _buildProductItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductPage(product: product)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Left Align everything
        children: [
          // Image Container
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[100], // Light grey background like screenshot
              child: Image.network(
                product.image, 
                fit: BoxFit.cover,
                // Fallback if image fails
                errorBuilder: (c, o, s) => const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Title
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold, // Bold Title
              fontSize: 16,
              color: Color(0xFF333333),
            ),
          ),
          
          const SizedBox(height: 5),

          // Price
          Text(
            '£${product.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700], // Dark Grey for price
            ),
          ),
        ],
      ),
    );
  }
}