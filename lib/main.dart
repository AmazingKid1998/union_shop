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
import 'pages/signup_page.dart'; // Added missing import

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
        final args = settings.arguments;

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

          case '/print-shack':
            return MaterialPageRoute(builder: (_) => const PrintShackMenuPage());
          case '/print-shack/tool':
            return MaterialPageRoute(builder: (_) => const PrintShackPage());
          case '/print-shack/about':
            return MaterialPageRoute(builder: (_) => const PrintShackAboutPage());

          // --- DYNAMIC ROUTES (FIXED) ---

          case '/product':
            if (args is Product) {
              return MaterialPageRoute(
                builder: (_) => ProductPage(product: args),
              );
            }
            return _errorRoute();

          case '/collection':
            // FIX: Check for generic 'Map' instead of 'Map<String, String>'
            // This prevents type errors if the map is inferred as <dynamic, dynamic>
            if (args is Map) {
              return MaterialPageRoute(
                builder: (_) => CollectionDetailPage(
                  collectionId: args['id'].toString(), // Safely convert to String
                  title: args['title'].toString(),
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

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found or invalid arguments')),
      );
    });
  }
}