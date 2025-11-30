import 'package:flutter/material.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';
import '../models/product.dart';
import '../models/cart.dart';
import 'cart_page.dart';

class PrintShackPage extends StatefulWidget {
  const PrintShackPage({super.key});

  @override
  State<PrintShackPage> createState() => _PrintShackPageState();
}

class _PrintShackPageState extends State<PrintShackPage> {
  final _textController = TextEditingController();

  // Define the image path here so we can use it in the display AND the cart
  final String _productImage = 'assets/images/print_preview.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Breadcrumb
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const Text('Home / Personalise Text', style: TextStyle(color: Colors.grey)),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Image Asset
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    // Use the local asset
                    child: Image.asset(
                      _productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if the user forgot to add the file
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                              SizedBox(height: 10),
                              Text('Add assets/images/print_shack.jpg', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 2. Product Details
                  const Text('Personalise Text', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Georgia')),
                  const SizedBox(height: 10),
                  const Text('£3.00', style: TextStyle(fontSize: 24, color: Colors.grey)),
                  
                  const SizedBox(height: 30),

                  // 3. The Input Form
                  const Text('Text', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      hintText: "Enter your custom text here..."
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 4. Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))
                      ),
                      onPressed: () {
                         if (_textController.text.isEmpty) {
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter text')));
                           return;
                         }

                         // Add to global cart
                         final customProduct = Product(
                           id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                           title: 'Personalise Text',
                           price: 3.00,
                           image: _productImage, // Pass the asset path to the cart!
                           description: 'Text: ${_textController.text}', 
                           collectionId: 'custom',
                         );

                         globalCart.add(customProduct);

                         // Navigate to Cart
                         Navigator.push(
                           context, 
                           MaterialPageRoute(builder: (context) => const CartPage())
                         ).then((_) => (context as Element).markNeedsBuild());
                      },
                      child: const Text('ADD TO CART', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
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
}