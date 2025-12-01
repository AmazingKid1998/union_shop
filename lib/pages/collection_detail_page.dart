import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/shop_viewmodel.dart';
import '../models/product.dart';
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
    // Filter products using the Shop ViewModel
    final shopVM = Provider.of<ShopViewModel>(context);
    final products = shopVM.getByCollection(collectionId);

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ),
            ),
            
            if (products.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Text('No products found in this collection.', style: TextStyle(color: Colors.grey)),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 30,
                    childAspectRatio: 0.70,
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

  Widget _buildProductItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductPage(product: product)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[100],
              child: Image.asset(product.image, fit: BoxFit.cover, errorBuilder: (c, o, s) => const Icon(Icons.image, size: 50, color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 12),
          
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 5),

          // Price Logic (handles sale)
          if (product.oldPrice != null)
            Row(
              children: [
                 Text('£${product.oldPrice!.toStringAsFixed(2)}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 13)),
                 const SizedBox(width: 5),
                 Text('£${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.blueGrey[800], fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            )
          else
            Text('£${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}