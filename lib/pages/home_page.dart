import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/shop_viewmodel.dart';
import '../models/product.dart';
import 'product_page.dart';       
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';
import '../widgets/home_carousel.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final shopVM = Provider.of<ShopViewModel>(context);
    final allProducts = shopVM.products;

    // 1. Get unique categories present in the product list
    final Set<String> uniqueCategories = {};
    for (var product in allProducts) {
      uniqueCategories.add(product.collectionId);
    }

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HomeCarousel(),
            
            const SizedBox(height: 40),

            const Text('Essential Range', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 20),
            
            // 2. Loop through each category and build a section
            if (allProducts.isEmpty)
               const Center(child: CircularProgressIndicator())
            else
               Column(
                 children: uniqueCategories.map((categoryId) {
                   // Find the first product for this category
                   final product = allProducts.firstWhere((p) => p.collectionId == categoryId);
                   
                   // Determine a display name for the category (simple mapping or formatting)
                   String categoryName = _formatCategoryName(categoryId);

                   return Column(
                     children: [
                       // Category Header
                       Padding(
                         padding: const EdgeInsets.symmetric(vertical: 15.0),
                         child: Text(
                           categoryName, 
                           style: const TextStyle(
                             fontSize: 18, 
                             fontWeight: FontWeight.bold, 
                             color: Colors.indigo
                           )
                         ),
                       ),
                       
                       // The Single Product Card
                       _buildProductItem(context, product),
                       
                       const SizedBox(height: 30), // Spacing between categories
                     ],
                   );
                 }).toList(),
               ),

            const SizedBox(height: 40),

            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  // Helper to make category IDs look nice (e.g. c_clothing -> Clothing)
  String _formatCategoryName(String id) {
    switch (id) {
      case 'c_clothing': return 'Clothing';
      case 'c_merch': return 'Merchandise';
      case 'c_halloween': return 'Halloween Collection';
      case 'c_grad': return 'Graduation';
      case 'c_city': return 'Portsmouth City';
      case 'c_pride': return 'Pride Collection';
      case 'c_signature': return 'Signature Range';
      default: return id.replaceAll('c_', '').toUpperCase();
    }
  }

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
        width: 200, // Slightly wider for this layout
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center align for this layout
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[200]!)
              ),
              child: Image.asset(product.image, fit: BoxFit.contain, errorBuilder: (c,o,s) => const Icon(Icons.image)),
            ),
            const SizedBox(height: 10),
            Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
            
            if (product.oldPrice != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text('£${product.oldPrice!.toStringAsFixed(2)}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 14)),
                   const SizedBox(width: 8),
                   Text('£${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.blueGrey[800], fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              )
            else
              Text('£${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
          ],
        ),
      ),
    );
  }
}