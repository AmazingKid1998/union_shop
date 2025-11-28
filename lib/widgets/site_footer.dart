import 'package:flutter/material.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100], // Light grey background like the real site
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
      width: double.infinity,
      child: Column(
        children: [
          // Desktop-style Multi-column layout
          Wrap(
            spacing: 50,
            runSpacing: 30,
            alignment: WrapAlignment.start,
            children: [
              // Column 1: Quick Links
              SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('QUICK LINKS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    SizedBox(height: 15),
                    Text('Search', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 8),
                    Text('About Us', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 8),
                    Text('Contact Us', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 8),
                    Text('Terms of Service', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 8),
                    Text('Refund policy', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              // Column 2: Get In Touch
              SizedBox(
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('GET IN TOUCH', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    SizedBox(height: 15),
                    Text(
                      'The Union Shop\nUniversity of Portsmouth Student Union\nCambridge Road\nPortsmouth\nPO1 2EF',
                      style: TextStyle(color: Colors.grey, height: 1.5),
                    ),
                    SizedBox(height: 15),
                    Text('shop@upsu.net', style: TextStyle(color: Colors.indigo, decoration: TextDecoration.underline)),
                  ],
                ),
              ),

               // Column 3: Newsletter (Simplified)
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NEWSLETTER', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    const SizedBox(height: 15),
                    const Text('Subscribe to receive updates, access to exclusive deals, and more.', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 15),
                    // Fake Input Field
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: const [
                          Expanded(child: Text('Enter your email address', style: TextStyle(color: Colors.grey))),
                          Icon(Icons.email_outlined, color: Colors.grey),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 20),

          // Bottom Section: Copyright & Payment Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  '© 2025 The Union Shop • Powered by Shopify',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              // Payment Icons (Using Icons as placeholders)
              Row(
                children: const [
                  Icon(Icons.credit_card, color: Colors.grey, size: 30),
                  SizedBox(width: 10),
                  Icon(Icons.payment, color: Colors.grey, size: 30),
                  SizedBox(width: 10),
                  Icon(Icons.account_balance_wallet, color: Colors.grey, size: 30),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}