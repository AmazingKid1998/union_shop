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
            const SizedBox(height: 40),
            
            // TITLE
            const Text(
              'The Union Print Shack',
              style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.bold, 
                color: Color(0xFF333333) // Dark Grey
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 30),

            // BANNER IMAGE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900), // Limit width on desktop
                child: Image.asset(
                  'assets/images/print_shack_about.webp', // Ensure this matches your file name exactly
                  fit: BoxFit.contain,
                  errorBuilder: (c,o,s) => Container(
                    height: 300, 
                    color: Colors.grey[200], 
                    child: const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey))
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // TEXT CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800), // Max width for readability
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      title: 'Make It Yours at The Union Print Shack',
                      text: 'Want to add a personal touch? We’ve got you covered with heat-pressed customisation on all our clothing. Swing by the shop - our team’s always happy to help you pick the right gear and answer any questions.'
                    ),
                    _buildSection(
                      title: 'Uni Gear or Your Gear - We’ll Personalise It',
                      text: 'Whether you’re repping your university or putting your own spin on a hoodie you already own, we’ve got you covered. We can personalise official uni-branded clothing and your own items - just bring them in and let’s get creative!'
                    ),
                    _buildSection(
                      title: 'Simple Pricing, No Surprises',
                      text: 'Customising your gear won’t break the bank - just £3 for one line of text or a small chest logo, and £5 for two lines or a large back logo. Turnaround time is up to three working days, and we’ll let you know as soon as it’s ready to collect.'
                    ),
                    _buildSection(
                      title: 'Personalisation Terms & Conditions',
                      text: 'We will print your clothing exactly as you have provided it to us, whether online or in person. We are not responsible for any spelling errors. Please ensure your chosen text is clearly displayed in either capitals or lowercase. Refunds are not provided for any personalised items.'
                    ),
                    _buildSection(
                      title: 'Ready to Make It Yours?',
                      text: 'Pop in or get in touch today - let’s create something uniquely you with our personalisation service - The Union Print Shack!'
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 80),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  // Helper widget to create consistent text blocks
  Widget _buildSection({required String title, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16, // Matches the small bold headers in the image
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15, // Standard body text
              height: 1.6, // Good line height for readability
              color: Color(0xFF666666), // Muted grey text color
            ),
          ),
        ],
      ),
    );
  }
}