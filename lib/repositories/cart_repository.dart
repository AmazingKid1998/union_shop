import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartRepository {
  List<Product> _cartItems = [];
  static const String _localKey = 'union_shop_cart';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user ID or null
  String? get _userId => _auth.currentUser?.uid;

  List<Product> getCartItems() {
    return _cartItems;
  }

  // --- LOAD CART (Smart Switch) ---
  Future<void> loadCart() async {
    if (_userId != null) {
      await _loadFromFirestore();
    } else {
      await _loadFromLocal();
    }
  }

  // --- SAVE CART (Smart Switch) ---
  Future<void> _saveCart() async {
    if (_userId != null) {
      await _saveToFirestore();
    } else {
      await _saveToLocal();
    }
  }

  // --- LOCAL STORAGE LOGIC ---
  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString(_localKey);
    if (cartJson != null) {
      final List<dynamic> decoded = json.decode(cartJson);
      _cartItems = decoded.map((item) => Product.fromJson(item)).toList();
    } else {
      _cartItems = [];
    }
  }

  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_cartItems.map((p) => p.toJson()).toList());
    await prefs.setString(_localKey, encoded);
  }

  // --- FIRESTORE LOGIC ---
  Future<void> _loadFromFirestore() async {
    try {
      final doc = await _firestore.collection('users').doc(_userId).collection('cart').doc('current').get();
      
      if (doc.exists && doc.data() != null) {
        final List<dynamic> data = doc.data()!['items'];
        _cartItems = data.map((item) => Product.fromJson(item)).toList();
      } else {
        _cartItems = [];
      }
    } catch (e) {
      print("Error loading Firestore cart: $e");
      _cartItems = [];
    }
  }

  Future<void> _saveToFirestore() async {
    try {
      // We store the entire cart list as one document for simplicity
      // In complex apps, each item might be a document, but this is fine for coursework.
      final List<Map<String, dynamic>> itemsJson = _cartItems.map((p) => p.toJson()).toList();
      
      await _firestore.collection('users').doc(_userId).collection('cart').doc('current').set({
        'items': itemsJson,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving to Firestore: $e");
    }
  }

  // --- MODIFICATION METHODS ---
  // Note: These methods call _saveCart(), which now routes to the correct storage
  
  Future<void> addItem(Product product) async {
    _cartItems.add(product);
    await _saveCart();
  }

  Future<void> removeAllById(String productId) async {
    _cartItems.removeWhere((p) => p.id == productId);
    await _saveCart();
  }
  
  Future<void> clear() async {
    _cartItems.clear();
    await _saveCart();
  }
  
  int getQuantity(Product product) {
    return _cartItems.where((p) => p.id == product.id).length;
  }
}