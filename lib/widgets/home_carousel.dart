import 'package:flutter/material.dart';
import '../pages/collections_page.dart';
import '../pages/print_shack_page.dart';

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({super.key});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Define the 2 slides from your screenshots
  final List<Map<String, dynamic>> _slides = [
    {
      'image': 'assets/images/print_preview.jpg', // Use your print shack image
      'title': 'The Print Shack',
      'description': 'Let’s create something uniquely you with our personalisation service — From £3 for one line of text!',
      'btnText': 'FIND OUT MORE',
      'route': '/print-shack', // Named route
    },
    {
      'image': 'assets/images/clothing_cat.jpg', // Use a clothing image
      'title': 'Essential Range -\nOver 20% OFF!',
      'description': 'Over 20% off our Essential Range. Come and grab yours while stock lasts!',
      'btnText': 'BROWSE COLLECTION',
      'route': '/shop', // Named route
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. THE SLIDER AREA
        SizedBox(
          height: 550, // Height to fit image + text below
          child: PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Column(
                children: [
                  // IMAGE SECTION
                  SizedBox(
                    height: 250, 
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            slide['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (c,o,s) => Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 50)),
                          ),
                        ),
                        // Pause Button (Visual Only - Matches screenshot)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.black45,
                            child: const Icon(Icons.pause, color: Colors.white, size: 20),
                          ),
                        )
                      ],
                    ),
                  ),

                  // TEXT SECTION
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      children: [
                        Text(
                          slide['title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32, 
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                            height: 1.2
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          slide['description'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey[600],
                            fontWeight: FontWeight.bold,
                            height: 1.5
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // BUTTON
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4B0082), // Dark Purple
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, slide['route']);
                            }, 
                            child: Text(
                              slide['btnText'], 
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)
                            )
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),

        // 2. THE DOTS INDICATOR
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left Arrow
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.grey),
              onPressed: () {
                _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              },
            ),
            
            // Dots
            ...List.generate(_slides.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.black87 : Colors.grey,
                ),
              );
            }),

            // Right Arrow
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.grey),
              onPressed: () {
                _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              },
            ),
          ],
        ),
      ],
    );
  }
}