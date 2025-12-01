import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../models/product.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, cartVM, child) {
        final uniqueProducts = cartVM.uniqueProducts;

        return Scaffold(
          appBar: const SiteHeader(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                
                const Text('Your cart', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                const SizedBox(height: 10),
                
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/shop');
                  },
                  child: const Text(
                    'Continue shopping',
                    style: TextStyle(decoration: TextDecoration.underline, fontSize: 16, color: Color(0xFF333333)),
                  ),
                ),

                const SizedBox(height: 40),

                // HEADERS (Hide on small screens if needed, but keeping for now)
                if (uniqueProducts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: const [
                        Text('Product', style: TextStyle(color: Colors.grey)),
                        Spacer(),
                        Text('Price', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                
                const Divider(),

                if (uniqueProducts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(child: Text('Your basket is empty.')),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true, 
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20), // Reduced padding
                    itemCount: uniqueProducts.length, 
                    separatorBuilder: (c, i) => const Divider(height: 40),
                    itemBuilder: (context, index) {
                      final product = uniqueProducts[index];
                      return CartItemRow(
                        key: ValueKey(product.id), 
                        product: product,
                        cartVM: cartVM,
                      );
                    },
                  ),

                if (uniqueProducts.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.grey[50], 
                    child: Column(
                      children: [
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.end,
                               children: [
                                 Row(
                                   children: [
                                     const Text('Subtotal', style: TextStyle(fontSize: 18)),
                                     const SizedBox(width: 20),
                                     Text('£${cartVM.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                   ],
                                 ),
                                 const SizedBox(height: 10),
                                 const Text('Shipping calculated at checkout.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                 const SizedBox(height: 20),
                                 SizedBox(
                                   width: 300, 
                                   child: ElevatedButton(
                                     style: ElevatedButton.styleFrom(
                                       backgroundColor: const Color(0xFF4B0082),
                                       padding: const EdgeInsets.symmetric(vertical: 18),
                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))
                                     ),
                                     onPressed: () {
                                       cartVM.clear(); 
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
    );
  }
}

class CartItemRow extends StatefulWidget {
  final Product product;
  final CartViewModel cartVM;

  const CartItemRow({
    super.key, 
    required this.product, 
    required this.cartVM,
  });

  @override
  State<CartItemRow> createState() => _CartItemRowState();
}

class _CartItemRowState extends State<CartItemRow> {
  bool _isEditing = false;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    final initialQuantity = widget.cartVM.getQuantity(widget.product);
    _quantityController = TextEditingController(text: initialQuantity.toString());
  }
  
  @override
  void didUpdateWidget(covariant CartItemRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing) {
      final newQuantity = widget.cartVM.getQuantity(widget.product);
      if (_quantityController.text != newQuantity.toString()) {
        _quantityController.text = newQuantity.toString();
      }
    }
  }
  
  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _updateQuantity() {
    int newQuantity = int.tryParse(_quantityController.text) ?? 1;
    if (newQuantity < 1) newQuantity = 1;
    widget.cartVM.updateQuantity(widget.product, newQuantity);
    setState(() {
      _isEditing = false;
    });
  }
  
  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _quantityController.text = widget.cartVM.getQuantity(widget.product).toString();
    });
  }
  
  void _removeAll() {
    widget.cartVM.removeAllById(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    final isCustom = widget.product.id.startsWith('custom_');
    int realCount = widget.cartVM.getQuantity(widget.product);
    double rowTotal = widget.product.price * realCount;
    
    if (!_isEditing && _quantityController.text != realCount.toString()) {
      _quantityController.text = realCount.toString();
    }

    // FIXED LAYOUT: Use IntrinsicHeight so the vertical line/spacing works better
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. PRODUCT IMAGE (Fixed Width)
          Container(
            width: 80, // Reduced slightly for mobile safety
            height: 80,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!)),
            child: Image.asset(widget.product.image, fit: BoxFit.cover, errorBuilder: (c,o,s) => const Icon(Icons.image_not_supported)),
          ),

          const SizedBox(width: 15),

          // 2. MIDDLE COLUMN (Expanded to take remaining space)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Qty
                Text(
                  realCount > 1 
                      ? '${widget.product.title} (x$realCount)'
                      : widget.product.title, 
                  style: const TextStyle(fontSize: 15, color: Color(0xFF333333), fontWeight: FontWeight.w600)
                ),
                
                const SizedBox(height: 5),

                if (isCustom) 
                  _buildCustomDetails(widget.product.description),
                  
                const SizedBox(height: 10),

                // --- EDIT MODE CONTROLS (WRAPPED FOR SAFETY) ---
                if (_isEditing)
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      // Remove Link
                      GestureDetector(
                        onTap: _removeAll,
                        child: const Text('Remove', style: TextStyle(decoration: TextDecoration.underline, color: Color(0xFF4B0082), fontSize: 13)),
                      ),
                      
                      // Quantity Row
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Qty ', style: TextStyle(fontSize: 13)),
                          SizedBox(
                            width: 40,
                            height: 30,
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13),
                              keyboardType: TextInputType.number,
                              controller: _quantityController,
                              decoration: const InputDecoration(contentPadding: EdgeInsets.zero, border: OutlineInputBorder()),
                              onSubmitted: (val) => _updateQuantity(),
                            ),
                          ),
                        ],
                      ),

                      // UPDATE BUTTON (Small)
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4B0082), 
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))
                          ),
                          onPressed: _updateQuantity, 
                          child: const Text('UPDATE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))
                        ),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('£${rowTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              
              SizedBox(
                height: 30,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10), 
                    side: const BorderSide(color: Color(0xFF4B0082)), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))
                  ),
                  onPressed: _isEditing ? _cancelEdit : () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  child: Text(_isEditing ? 'CANCEL' : 'EDIT', style: const TextStyle(fontSize: 11, color: Color(0xFF4B0082), fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCustomDetails(String description) {
    if (!description.contains(':')) return Text(description, style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.grey));
    try {
      final int splitIndex = description.indexOf(':');
      final String optionName = description.substring(0, splitIndex);
      final String content = description.substring(splitIndex + 1).trim();
      final List<String> lines = content.split(' / ');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Per Line: $optionName', style: TextStyle(color: Colors.blueGrey[700], fontSize: 12, fontStyle: FontStyle.italic)),
          ...List.generate(lines.length, (index) {
            return Text('Line ${index + 1}: ${lines[index]}', style: TextStyle(color: Colors.blueGrey[600], fontSize: 12, fontStyle: FontStyle.italic));
          }),
        ],
      );
    } catch (e) {
      return Text(description, style: const TextStyle(color: Colors.grey));
    }
  }
}