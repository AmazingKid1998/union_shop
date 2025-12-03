import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ViewModels
import 'viewmodels/shop_viewmodel.dart';
import 'viewmodels/cart_viewmodel.dart';

// Models
import 'models/product.dart';
// REPO IMPORT (Crucial for looking up products by ID from the URL)
import 'repositories/product_repository.dart'; 

// Pages
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/collections_page.dart';
import 'pages/collection_detail_page.dart';
import 'pages/product_page.dart';
import 'pages/print_shack_page.dart'; 
import 'pages/print_shack_menu_page.dart'; 
import 'pages/print_shack_about_page.dart'; 
import 'pages/cart_page.dart';
import 'pages/login_page.dart';
import 'pages/sale_page.dart';
import 'pages/signup_page.dart'; 

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShopViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
      ],
      child: const UnionShopApp(),
    ),
  );
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/',
      
      onGenerateRoute: (settings) {
        // 1. Handle "/" (Home)
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (_) => const HomePage());
        }

        // 2. Parse the URI to handle deep links
        final uri = Uri.parse(settings.name ?? '');
        
        // --- ROUTE: COLLECTION DETAILS ---
        // Matches: /collection/c_clothing
        if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'collection') {
          final id = uri.pathSegments[1];
          final title = _getCollectionTitle(id); 
          
          return MaterialPageRoute(
            builder: (_) => CollectionDetailPage(
              collectionId: id,
              title: title,
            ),
            settings: settings,
          );
        }

        // --- ROUTE: PRODUCT DETAILS (NEW) ---
        // Matches: /product/p_classic_hoodie
        if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'product') {
          final id = uri.pathSegments[1];
          
          // Look up the product using the Repository based on the ID from URL
          // (Since your dummy data is local/sync, this works immediately)
          final product = ProductRepository().getProductById(id);
          
          return MaterialPageRoute(
            builder: (_) => ProductPage(product: product),
            settings: settings,
          );
        }

        // --- STATIC ROUTES ---
        switch (settings.name) {
          case '/about':
            return MaterialPageRoute(builder: (_) => const AboutPage());
          case '/shop':
            return MaterialPageRoute(builder: (_) => const CollectionsPage());
          case '/cart':
            return MaterialPageRoute(builder: (_) => const CartPage());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/sale':
            return MaterialPageRoute(builder: (_) => const SalePage());
          case '/print-shack':
            return MaterialPageRoute(builder: (_) => const PrintShackMenuPage());
          case '/print-shack/tool':
            return MaterialPageRoute(builder: (_) => const PrintShackPage());
          case '/print-shack/about':
            return MaterialPageRoute(builder: (_) => const PrintShackAboutPage());
        }

        return _errorRoute();
      },
    );
  }

  // Helper to map IDs to Titles
  String _getCollectionTitle(String id) {
    switch (id) {
      case 'c_clothing': return 'Clothing';
      case 'c_merch': return 'Merchandise';
      case 'c_halloween': return 'Halloween 🎃';
      case 'c_grad': return 'Graduation 🎓';
      case 'c_city': return 'Portsmouth City';
      case 'c_pride': return 'Pride 🏳️‍🌈';
      case 'c_signature': return 'Signature Range';
      default: return 'Collection';
    }
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found or invalid arguments')),
      );
    });
  }
}