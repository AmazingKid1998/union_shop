import 'package:flutter/material.dart';
import '../models/cart.dart'; // Import the global list
import '../models/product.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';
import 'collections_page.dart'; // Import to navigate to shop

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Method to refresh the main cart total when an item updates
  void _refreshCart() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            
            // TITLE SECTION
            const Text(
              'Your cart', 
              style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333)
              )
            ),
            const SizedBox(height: 10),
            
            // 1. CONTINUE SHOPPING LINK
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const CollectionsPage()));
              },
              child: const Text(
                'Continue shopping',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                  color: Color(0xFF333333)
                ),
              ),
            ),

            const SizedBox(height: 40),

            // TABLE HEADERS (Desktop style)
            if (globalCart.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    const Text('Product', style: TextStyle(color: Colors.grey)),
                    const Spacer(),
                    const Text('Price', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            
            const Divider(),

            // CART LIST
            if (globalCart.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(child: Text('Your basket is empty.')),
              )
            else
              ListView.separated(
                shrinkWrap: true, // Important inside SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: globalCart.length,
                separatorBuilder: (c, i) => const Divider(height: 40),
                itemBuilder: (context, index) {
                  return CartItemRow(
                    product: globalCart[index],
                    onRemove: () {
                      setState(() {
                        globalCart.removeAt(index);
                      });
                    },
                    onUpdate: _refreshCart,
                  );
                },
              ),

            // FOOTER / CHECKOUT SECTION
            if (globalCart.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.grey[50], 
                child: Column(
                  children: [
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Align to right
                      children: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.end,
                           children: [
                             Row(
                               children: [
                                 const Text('Subtotal', style: TextStyle(fontSize: 18)),
                                 const SizedBox(width: 20),
                                 Text('£${getCartTotal().toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                               ],
                             ),
                             const SizedBox(height: 10),
                             const Text('Shipping, taxes, and discounts codes calculated at checkout.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                             const SizedBox(height: 20),
                             SizedBox(
                               width: 300, // Fixed width button like screenshot
                               child: ElevatedButton(
                                 style: ElevatedButton.styleFrom(
                                   backgroundColor: const Color(0xFF4B0082), // Dark Purple
                                   padding: const EdgeInsets.symmetric(vertical: 18),
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))
                                 ),
                                 onPressed: () {
                                   setState(() {
                                      globalCart.clear();
                                   });
                                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order Placed!')));
                                 },
                                 child: const Text('Check out', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                               ),
                             ),
                           ],
                         )
                      ],
                    ),
                  ],
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

// --- NEW WIDGET: CART ITEM ROW (Handles Edit Logic) ---
class CartItemRow extends StatefulWidget {
  final Product product;
  final VoidCallback onRemove;
  final VoidCallback onUpdate;

  const CartItemRow({
    super.key, 
    required this.product, 
    required this.onRemove,
    required this.onUpdate,
  });

  @override
  State<CartItemRow> createState() => _CartItemRowState();
}

class _CartItemRowState extends State<CartItemRow> {
  bool _isEditing = false;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    // Check if this is a custom item
    final isCustom = widget.product.id.startsWith('custom_');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. PRODUCT IMAGE
        Container(
          width: 100,
          height: 100, // Slightly bigger
          child: Image.asset(
            widget.product.image, 
            fit: BoxFit.cover,
            errorBuilder: (c,o,s) => const Icon(Icons.image_not_supported),
          ),
        ),

        const SizedBox(width: 20),

        // 2. MIDDLE COLUMN (Title + Details + Edit Controls)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.title, 
                style: const TextStyle(
                  fontSize: 16, 
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w500
                )
              ),
              const SizedBox(height: 8),

              // CUSTOM PARSING LOGIC (Only if NOT editing or if we want to show it always)
              if (isCustom) 
                _buildCustomDetails(widget.product.description),
                
              const SizedBox(height: 15),

              // --- EDIT MODE CONTROLS ---
              if (_isEditing)
                Row(
                  children: [
                    // Remove Link
                    GestureDetector(
                      onTap: widget.onRemove,
                      child: const Text(
                        'Remove', 
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xFF4B0082)
                        )
                      ),
                    ),
                    
                    const Spacer(),
                    
                    const Text('Quantity  '),
                    // Quantity Box
                    SizedBox(
                      width: 50,
                      height: 35,
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: '$_quantity'),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) {
                          _quantity = int.tryParse(val) ?? 1;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),

                    // UPDATE BUTTON
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B0082),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))
                      ),
                      onPressed: () {
                         setState(() {
                           _isEditing = false;
                           // In a real app, we would update the cart quantity here.
                           // For this coursework, we just close the edit mode.
                           widget.onUpdate();
                         });
                      }, 
                      child: const Text('UPDATE', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))
                    )
                  ],
                ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        // 3. RIGHT COLUMN (Price + Edit/Cancel Button)
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '£${widget.product.price.toStringAsFixed(2)}', 
              style: const TextStyle(fontSize: 16)
            ),
            const SizedBox(height: 10),
            
            // EDIT / CANCEL BUTTON
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                side: const BorderSide(color: Color(0xFF4B0082)), // Purple border
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                minimumSize: const Size(0, 30),
              ),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing; // Toggle Edit Mode
                });
              },
              child: Text(
                _isEditing ? 'CANCEL' : 'EDIT', 
                style: const TextStyle(fontSize: 12, color: Color(0xFF4B0082), fontWeight: FontWeight.bold)
              ),
            ),
          ],
        )
      ],
    );
  }

  // --- HELPER TO PARSE TEXT ---
  Widget _buildCustomDetails(String description) {
    if (!description.contains(':')) return Text(description, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey));

    try {
      final int splitIndex = description.indexOf(':');
      final String optionName = description.substring(0, splitIndex);
      final String content = description.substring(splitIndex + 1).trim();
      final List<String> lines = content.split(' / ');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Per Line: $optionName', 
            style: TextStyle(color: Colors.blueGrey[700], fontSize: 13, fontStyle: FontStyle.italic)
          ),
          const SizedBox(height: 5),
          ...List.generate(lines.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personalisation', 
                    style: TextStyle(color: Colors.blue[800], fontSize: 13)
                  ),
                  Text(
                    'Line ${index + 1}: ${lines[index]}',
                    style: TextStyle(color: Colors.blueGrey[600], fontSize: 13, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            );
          }),
        ],
      );
    } catch (e) {
      return Text(description, style: const TextStyle(color: Colors.grey));
    }
  }
}