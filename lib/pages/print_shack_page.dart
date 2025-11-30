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
  final String _productImage = 'assets/images/print_preview.jpg';

  // 1. The List of Options from your image
  final List<String> _customisationOptions = [
    'One Line of Text',
    'Two Lines of Text',
    'Three Lines of Text',
    'Four Lines of Text',
    'Small Logo (Chest)',
    'Large Logo (Back)'
  ];

  // 2. Track the selected value
  String? _selectedOption;

  // 3. Dynamic Price Calculator
  double get _currentPrice {
    double basePrice = 3.00;
    // If an option is selected, add £2.50
    if (_selectedOption != null) {
      return basePrice + 2.50;
    }
    return basePrice;
  }

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
                  // IMAGE
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Image.asset(
                      _productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Center(
                        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey)
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // DETAILS HEADER
                  const Text('Personalise Text', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Georgia')),
                  const SizedBox(height: 10),
                  
                  // DYNAMIC PRICE DISPLAY
                  Text(
                    '£${_currentPrice.toStringAsFixed(2)}', 
                    style: const TextStyle(fontSize: 24, color: Colors.grey)
                  ),
                  
                  const SizedBox(height: 30),

                  // --- NEW DROPDOWN SECTION ---
                  const Text('Choose one', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedOption,
                        isExpanded: true,
                        hint: const Text("Select an option"),
                        items: _customisationOptions.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedOption = newValue;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // TEXT INPUT FORM
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

                  // ADD TO CART BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))
                      ),
                      onPressed: () {
                         // Validation
                         if (_selectedOption == null) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an option from the dropdown')));
                            return;
                         }
                         if (_textController.text.isEmpty) {
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your text')));
                           return;
                         }

                         // Add to global cart
                         final customProduct = Product(
                           id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                           title: 'Personalise Text',
                           // USE THE DYNAMIC PRICE HERE
                           price: _currentPrice,
                           image: _productImage,
                           // Save both the Option and the Text in the description
                           description: '$_selectedOption: "${_textController.text}"', 
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