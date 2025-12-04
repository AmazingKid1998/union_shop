import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/pages/home_page.dart';
import 'package:union_shop/pages/about_page.dart';

// Import the helper
import '../firebase_mock.dart';

Widget createScreenForTesting(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ShopViewModel()),
      ChangeNotifierProvider(create: (_) => CartViewModel()),
    ],
    child: MaterialApp(home: child),
  );
}

void main() {
  // 1. Setup Mocks
  setupFirebaseMocks();

  setUpAll(() async {
    // 2. Init Firebase
    await Firebase.initializeApp();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Page Smoke Tests', () {
    testWidgets('HomePage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createScreenForTesting(const HomePage()));
      await tester.pumpAndSettle(); 
      
      expect(find.text('The '), findsWidgets); 
      expect(find.text('Shop'), findsWidgets); 
    });

    testWidgets('AboutPage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createScreenForTesting(const AboutPage()));
      await tester.pumpAndSettle();

      expect(find.text('About us'), findsOneWidget);
    });
  });
}