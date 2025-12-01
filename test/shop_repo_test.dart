import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('Product Repository and ViewModel Tests', () {
    late ProductRepository repo;
    late ShopViewModel shopVM;

    setUpAll(() {
      // Since the data is synchronous and internal to the repository, 
      // we don't need the full Flutter binding here, only the setup for the repository.
      repo = ProductRepository();
      shopVM = ShopViewModel(); // This triggers internal data load
    });
    
    // --- REPOSITORY TESTS (Data Integrity) ---

    test('Repository loads correct number of total products', () async {
      final products = await repo.getAllProducts();
      // Based on the final list we consolidated (3+2+1+2+2+5=15 items total)
      expect(products.length, 15);
    });

    test('getProductsByCollection returns only Clothing items', () {
      final clothing = repo.getProductsByCollection('c_clothing');
      // Should find Classic Hoodie, Essential Tee, Signature Tee (3 items)
      expect(clothing.length, 3);
      expect(clothing.any((p) => p.collectionId == 'c_merch'), isFalse);
      expect(clothing.any((p) => p.collectionId == 'c_halloween'), isFalse);
    });

    test('getSaleProducts returns only items with oldPrice', () {
      final saleItems = repo.getSaleProducts();
      // Should find Classic Hoodie (c_clothing), Lanyard (c_merch), Uni Pen (c_merch) (3 items)
      expect(saleItems.length, 3); 
      expect(saleItems.every((p) => p.oldPrice != null), isTrue);
    });

    // --- VIEWMODEL TESTS (Search & Filtering) ---
    
    test('ViewModel search is case-insensitive and filters correctly', () async {
      // Ensure ViewModel has loaded data first
      final loadedProducts = await shopVM.products; 
      expect(loadedProducts, isNotEmpty);
      
      // Test 1: Case-insensitive search for a specific item
      final result1 = shopVM.search('hoodie'); 
      expect(result1.length, 2); // Classic Hoodie, Graduation Hoodie 2025
      
      // Test 2: Search for a common term
      final result2 = shopVM.search('tee'); 
      expect(result2.length, 2); // Essential T-Shirt, Signature T-Shirt
    });

    test('ViewModel correctly identifies variants on a product', () {
      final hoodie = shopVM.getProductById('p_classic_hoodie');
      // Should have 3 variants (Grey, Navy, Purple)
      expect(hoodie.variants, isNotNull);
      expect(hoodie.variants!.length, 3);
      expect(hoodie.variants!.containsKey('Grey'), isTrue);
    });
  });
}