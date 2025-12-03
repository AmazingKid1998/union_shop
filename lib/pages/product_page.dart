import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../models/product.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({super.key, required this.product});
  
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _quantity = 1; 
  
  late String _currentImage;
  String? _selectedVariant;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.product.image;
    
    if (widget.product.variants != null && widget.product.variants!.isNotEmpty) {
      _selectedVariant = widget.product.variants!.keys.first;
      _currentImage = widget.product.variants![_selectedVariant]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartVM = Provider.of<CartViewModel>(context, listen: false);
    final product = widget.product;
    final bool isOnSale = product.oldPrice != null;
    final bool hasVariants = product.variants != null && product.variants!.isNotEmpty;

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product Image
            Container(
              height: 350,
              width: double.infinity,
              color: Colors.white,
              child: Image.asset(
                _currentImage, 
                fit: BoxFit.contain,
                errorBuilder: (c,o,s) => const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey)),
              ),
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
                  
                  // Price Logic
                  if (isOnSale)
                    Row(
                      children: [
                        Text(
                          '£${product.oldPrice!.toStringAsFixed(2)}',
                          style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 18),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '£${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  else
                    Text(
                      '£${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 22, color: Colors.indigo, fontWeight: FontWeight.bold),
                    ),
                    
                  const SizedBox(height: 20),
                  
                  // 2. VARIANT SELECTOR
                  if (hasVariants) ...[
                    Text('Select Option: ${_selectedVariant ?? ''}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: product.variants!.entries.map((entry) {
                        final bool isSelected = _selectedVariant == entry.key;
                        return ChoiceChip(
                          label: Text(entry.key),
                          selected: isSelected,
                          selectedColor: Colors.indigo.withOpacity(0.2),
                          onSelected: (bool selected) {
                            if (selected) {
                              setState(() {
                                _selectedVariant = entry.key;
                                _currentImage = entry.value; // Update the main image!
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                  ),
                  const SizedBox(height: 30),
                  
                  // Quantity Selector
                  const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildQuantityButton(context, Icons.remove, () {
                        setState(() {
                          if (_quantity > 1) _quantity--;
                        });
                      }),
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Text(_quantity.toString(), style: const TextStyle(fontSize: 18)),
                      ),
                      _buildQuantityButton(context, Icons.add, () {
                        setState(() {
                          _quantity++;
                        });
                      }),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                      ),
                      onPressed: () {
                         // Build the unique product instance for the cart
                         final cartProduct = Product(
                           id: product.id + (_selectedVariant ?? ''),
                           title: hasVariants ? '${product.title}' : product.title, 
                           price: product.price,
                           image: _currentImage, 
                           description: 'Variant: ${_selectedVariant ?? 'Default'}', // Save variant in description
                           collectionIds: product.collectionIds, // UPDATED: Pass list
                           oldPrice: product.oldPrice
                         );

                         for (int i = 0; i < _quantity; i++) {
                           cartVM.add(cartProduct);
                         }
                         
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('${product.title} added (x$_quantity)!'))
                         );
                         
                         // NAV CHANGE: Use Named Route for Cart
                         Navigator.pushNamed(context, '/cart');
                      },
                      child: const Text('ADD TO CART', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
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

  Widget _buildQuantityButton(BuildContext context, IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
      ),
    );
  }
}