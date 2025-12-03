import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ViewModels
import 'viewmodels/shop_viewmodel.dart';
import 'viewmodels/cart_viewmodel.dart';

// Models
import 'models/product.dart';

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
      
      // Replaces 'routes' with dynamic generation logic
      onGenerateRoute: (settings) {
        // 1. Extract arguments (if any)
        final args = settings.arguments;

        // 2. Switch statement to return the correct page
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomePage());
          
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

          // Print Shack Routes
          case '/print-shack':
            return MaterialPageRoute(builder: (_) => const PrintShackMenuPage());
          case '/print-shack/tool':
            return MaterialPageRoute(builder: (_) => const PrintShackPage());
          case '/print-shack/about':
            return MaterialPageRoute(builder: (_) => const PrintShackAboutPage());

          // --- DYNAMIC ROUTES (WITH ARGUMENTS) ---

          case '/product':
            // Validation: Ensure args is a Product object
            if (args is Product) {
              return MaterialPageRoute(
                builder: (_) => ProductPage(product: args),
              );
            }
            return _errorRoute();

          case '/collection':
            // Validation: Ensure args is a Map with id and title
            if (args is Map<String, String>) {
              return MaterialPageRoute(
                builder: (_) => CollectionDetailPage(
                  collectionId: args['id']!,
                  title: args['title']!,
                ),
              );
            }
            return _errorRoute();

          default:
            return _errorRoute();
        }
      },
    );
  }

  // Fallback for invalid routes/arguments
  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found or invalid arguments')),
      );
    });
  }
}