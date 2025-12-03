import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ViewModels
import 'viewmodels/shop_viewmodel.dart';
import 'viewmodels/cart_viewmodel.dart';

// Models
import 'models/product.dart';
// REPO IMPORT
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
          return MaterialPageRoute(
            builder: (_) => const HomePage(),
            settings: settings, // FIX: Pass settings here
          );
        }

        // 2. Parse the URI to handle deep links
        final uri = Uri.parse(settings.name ?? '');
        
        // --- ROUTE: COLLECTION DETAILS ---
        if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'collection') {
          final id = uri.pathSegments[1];
          final title = _getCollectionTitle(id); 
          
          return MaterialPageRoute(
            builder: (_) => CollectionDetailPage(
              collectionId: id,
              title: title,
            ),
            settings: settings, // This was already correct
          );
        }

        // --- ROUTE: PRODUCT DETAILS ---
        if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'product') {
          final id = uri.pathSegments[1];
          final product = ProductRepository().getProductById(id);
          
          return MaterialPageRoute(
            builder: (_) => ProductPage(product: product),
            settings: settings, // This was already correct
          );
        }

        // --- STATIC ROUTES (FIXED) ---
        // Added 'settings: settings' to ALL routes below to fix URL updates
        switch (settings.name) {
          case '/about':
            return MaterialPageRoute(builder: (_) => const AboutPage(), settings: settings);
          case '/shop':
            return MaterialPageRoute(builder: (_) => const CollectionsPage(), settings: settings);
          case '/cart':
            return MaterialPageRoute(builder: (_) => const CartPage(), settings: settings);
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage(), settings: settings);
          case '/sale':
            return MaterialPageRoute(builder: (_) => const SalePage(), settings: settings);
          case '/print-shack':
            return MaterialPageRoute(builder: (_) => const PrintShackMenuPage(), settings: settings);
          case '/print-shack/tool':
            return MaterialPageRoute(builder: (_) => const PrintShackPage(), settings: settings);
          case '/print-shack/about':
            return MaterialPageRoute(builder: (_) => const PrintShackAboutPage(), settings: settings);
        }

        return _errorRoute();
      },
    );
  }

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