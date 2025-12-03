import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/shop_viewmodel.dart';
import '../models/product.dart';
import 'product_page.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

class SalePage extends StatelessWidget {
  const SalePage({super.key});

  @override
  Widget build(BuildContext context) {
    final shopVM = Provider.of<ShopViewModel>(context);
    final saleProducts = shopVM.getSaleItems();

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    'SALE',
                    style: TextStyle(
                      fontSize: 36, 
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333), // Dark grey
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Don’t miss out! Get yours before they’re all gone!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'All prices shown are inclusive of the discount',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey[400],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(Icons.shopping_cart_outlined, size: 16, color: Colors.blueGrey[400]),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: saleProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65, 
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 30,
                ),
                itemBuilder: (context, index) {
                  return _buildSaleCard(context, saleProducts[index]);
                },
              ),
            ),
            const SizedBox(height: 40),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSaleCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        // NAV CHANGE: Use Named Route with Argument
        Navigator.pushNamed(
          context, 
          '/product', 
          arguments: product
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white, 
              child: Image.asset(product.image, fit: BoxFit.cover, errorBuilder: (c,o,s) => const Icon(Icons.image_not_supported, color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 12),
          
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blueGrey[800],
            ),
          ),
          const SizedBox(height: 5),

          Row(
            children: [
              Text(
                '£${product.oldPrice!.toStringAsFixed(2)}',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 2,
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '£${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}