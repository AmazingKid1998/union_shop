import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:union_shop/viewmodels/cart_viewmodel.dart';
import 'package:union_shop/models/product.dart';

// --- HELPER: Manual Mock for Firebase ---
void setupFirebaseAuthMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // 1. Mock Firebase Core (Handles Firebase.initializeApp)
  const MethodChannel channel = MethodChannel('plugins.flutter.io/firebase_core');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    channel,
    (MethodCall methodCall) async {
      if (methodCall.method == 'Firebase#initializeCore') {
        return [
          {
            'name': '[DEFAULT]',
            'options': {
              'apiKey': '123',
              'appId': '123',
              'messagingSenderId': '123',
              'projectId': '123',
            },
            'pluginConstants': {},
          }
        ];
      }
      if (methodCall.method == 'Firebase#initializeApp') {
        return {
          'name': methodCall.arguments['appName'],
          'options': methodCall.arguments['options'],
          'pluginConstants': {},
        };
      }
      return null;
    },
  );

  // 2. Mock Firebase Auth (Prevents crashes when Auth listens to streams)
  const MethodChannel authChannel = MethodChannel('plugins.flutter.io/firebase_auth');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    authChannel,
    (MethodCall methodCall) async {
      return null; // Return null for all auth calls to simulate "no user logged in"
    },
  );
}

void main() {
  // Call our manual mock helper
  setupFirebaseAuthMocks();

  late CartViewModel cartVM;

  setUpAll(() async {
    // Now this call will succeed because we mocked the channel above
    await Firebase.initializeApp();
  });

  setUp(() {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    cartVM = CartViewModel();
  });

  group('CartViewModel Tests', () {
    final testProduct = Product(
      id: 'test_p', 
      title: 'Test', 
      price: 10.0, 
      image: 'img', 
      description: 'desc', 
      collectionIds: []
    );

    test('Starts empty', () {
      expect(cartVM.uniqueProducts, isEmpty);
      expect(cartVM.totalPrice, 0.0);
    });

    test('Add item increases count and price', () {
      cartVM.add(testProduct);
      
      expect(cartVM.uniqueProducts.length, 1);
      expect(cartVM.getQuantity(testProduct), 1);
      expect(cartVM.totalPrice, 10.0);
    });

    test('Update quantity modifies cart', () {
      cartVM.add(testProduct);
      cartVM.updateQuantity(testProduct, 3);

      expect(cartVM.getQuantity(testProduct), 3);
      expect(cartVM.totalPrice, 30.0);
    });

    test('Clear empties the cart', () {
      cartVM.add(testProduct);
      cartVM.clear();
      expect(cartVM.uniqueProducts, isEmpty);
    });
  });
}