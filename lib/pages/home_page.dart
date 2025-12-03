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

    // 1. Get unique categories
    // We iterate through all products. Since a product has multiple IDs,
    // we take the FIRST ID as its "Primary" category for the homepage display.
    final Map<String, Product> categoryMap = {};
    
    for (var product in allProducts) {
      if (product.collectionIds.isNotEmpty) {
        String primaryCategory = product.collectionIds.first;
        if (!categoryMap.containsKey(primaryCategory)) {
          categoryMap[primaryCategory] = product;
        }
      }
    }

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HomeCarousel(),
            
            const SizedBox(height: 40),
            
            if (categoryMap.isEmpty)
               const Center(child: CircularProgressIndicator())
            else
               Column(
                 children: categoryMap.entries.map((entry) {
                   String categoryId = entry.key;
                   Product product = entry.value;
                   
                   String categoryName = _formatCategoryName(categoryId);

                   return Column(
                     children: [
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
                       _buildProductItem(context, product),
                       const SizedBox(height: 30),
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

  String _formatCategoryName(String id) {
    switch (id) {
      case 'c_clothing': return 'Clothing';
      case 'c_merch': return 'Merchandise';
      case 'c_halloween': return 'Halloween Collection';
      case 'c_grad': return 'Graduation';
      case 'c_city': return 'Portsmouth City';
      case 'c_pride': return 'Pride Collection';
      case 'c_signature': return 'Signature Range';
      case 'c_essential': return 'Essential Range'; // Added this
      default: return id.replaceAll('c_', '').toUpperCase();
    }
  }

  Widget _buildProductItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product/${product.id}');
      },
      child: Container(
        width: 200,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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