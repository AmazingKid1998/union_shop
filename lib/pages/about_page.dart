import 'package:flutter/material.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(), // Reusing the Navbar
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'About The Union Shop',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'We are the official shop of the University of Portsmouth Student Union. '
                    'All proceeds go back into funding student services and activities.',
                    style: TextStyle(fontSize: 18, height: 1.5),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Contact Us:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('Email: shop@upsu.net\nLocation: The Union Building, Cambridge Road'),
                ],
              ),
            ),
            const SiteFooter(), // Reusing the Footer
          ],
        ),
      ),
    );
  }
}