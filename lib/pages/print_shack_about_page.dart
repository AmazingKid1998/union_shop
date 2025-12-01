import 'package:flutter/material.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

class PrintShackAboutPage extends StatelessWidget {
  const PrintShackAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  const Text(
                    'About The Print Shack',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 800, // Limit width for readability
                    child: const Text(
                      'Welcome to The Print Shack, your destination for customised university gear.\n\n'
                      'We offer high-quality printing services on hoodies, t-shirts, and tote bags. '
                      'Whether you want your name, your society, or a custom slogan, we can make it happen.\n\n'
                      'All our printing is done in-house by our student team, ensuring quick turnaround times and professional quality.',
                      style: TextStyle(fontSize: 18, height: 1.6, color: Colors.blueGrey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}