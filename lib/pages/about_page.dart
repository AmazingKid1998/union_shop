import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Needed for the clickable text
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';
import 'print_shack_page.dart'; // Import to link the personalisation service

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a standard style for the body text to keep it consistent
    final bodyStyle = TextStyle(
      fontSize: 16, 
      height: 1.6, 
      color: Colors.blueGrey[600]
    );

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
              child: Column(
                children: [
                  // TITLE
                  const Text(
                    'About us',
                    style: TextStyle(
                      fontSize: 32, 
                      fontWeight: FontWeight.bold, 
                      color: Color(0xFF333333) // Dark grey/black like the image
                    ),
                  ),
                  const SizedBox(height: 40),

                  // PARA 1
                  Text(
                    'Welcome to the Union Shop!',
                    style: bodyStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // PARA 2 (With the clickable link inside)
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: bodyStyle, // Inherit base style
                      children: [
                        const TextSpan(
                          text: 'We’re dedicated to giving you the very best University branded products, with a range of clothing and merchandise available to shop all year round! We even offer an exclusive '
                        ),
                        TextSpan(
                          text: 'personalisation service',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blueGrey, // Keeps color consistent but underlined
                            fontWeight: FontWeight.w500
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PrintShackPage()),
                              );
                            },
                        ),
                        const TextSpan(text: '!'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // PARA 3
                  Text(
                    'All online purchases are available for delivery or instore collection!',
                    style: bodyStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // PARA 4
                  Text(
                    'We hope you enjoy our products as much as we enjoy offering them to you. If you have any questions or comments, please don’t hesitate to contact us at hello@upsu.net.',
                    style: bodyStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // PARA 5
                  Text(
                    'Happy shopping!',
                    style: bodyStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // SIGNATURE
                  Text(
                    'The Union Shop & Reception Team',
                    style: TextStyle(
                      fontSize: 16, 
                      color: Colors.blueGrey[500] // Slightly lighter for signature
                    ),
                    textAlign: TextAlign.center,
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