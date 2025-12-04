import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/shop_viewmodel.dart';
import '../models/product.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';
import '../viewmodels/shop_viewmodel.dart' show SortOption;

const Map<String, double> priceRanges = {
  'All Prices': 1000.0, 
  'Under £10': 9.99,
  '£10 - £20': 20.00,
  'Over £20': 1000.0, 
};

class CollectionDetailPage extends StatefulWidget {
  final String collectionId;
  final String title;
  
  // NEW: Optional test Header
  final PreferredSizeWidget? testHeader;

  const CollectionDetailPage({
    super.key, 
    required this.collectionId, 
    required this.title,
    this.testHeader,
  });

  @override
  State<CollectionDetailPage> createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends State<CollectionDetailPage> {
  SortOption? _selectedSort;
  String _selectedPriceRange = priceRanges.keys.first; 

  @override
  Widget build(BuildContext context) {
    double maxPriceFilter = priceRanges[_selectedPriceRange]!;
    
    final shopVM = Provider.of<ShopViewModel>(context);
    
    final products = shopVM.getByCollection(
      widget.collectionId, 
      sortOption: _selectedSort,
      maxPrice: maxPriceFilter, 
      priceRangeName: _selectedPriceRange 
    );

    return Scaffold(
      // UPDATED: Use testHeader
      appBar: widget.testHeader ?? const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<SortOption>(
                        hint: const Text('Sort By'),
                        value: _selectedSort,
                        onChanged: (SortOption? newValue) {
                          setState(() {
                            _selectedSort = newValue;
                          });
                        },
                        items: const [
                          DropdownMenuItem(value: SortOption.priceLowToHigh, child: Text('Price: Low to High')),
                          DropdownMenuItem(value: SortOption.priceHighToLow, child: Text('Price: High to Low')),
                          DropdownMenuItem(value: SortOption.nameAZ, child: Text('Name: A-Z')),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      DropdownButton<String>(
                        value: _selectedPriceRange,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPriceRange = newValue!;
                          });
                        },
                        items: priceRanges.keys.map((String range) {
                          return DropdownMenuItem<String>(
                            value: range,
                            child: Text('Filter: $range'),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            if (products.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Text('No products match your filter.', style: TextStyle(color: Colors.grey)),
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
        Navigator.pushNamed(context, '/product/${product.id}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[100],
              child: Image.asset(
                product.image, 
                fit: BoxFit.cover, 
                errorBuilder: (c, o, s) => const Icon(Icons.image, size: 50, color: Colors.grey)
              ),
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