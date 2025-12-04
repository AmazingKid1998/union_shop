import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';

void main() {
  group('ShopViewModel Logic Tests', () {
    late ShopViewModel viewModel;

    setUp(() {
      viewModel = ShopViewModel();
    });

    // --- TEST 1: INITIALIZATION ---
    test('Loads products on initialization', () async {
      // Wait for the async constructor to finish fetching data
      await Future.delayed(const Duration(milliseconds: 100));
      expect(viewModel.products.isNotEmpty, true);
    });

    // --- TEST 2: SEARCH LOGIC ---
    test('Search filters by title (case insensitive)', () async {
      await Future.delayed(const Duration(milliseconds: 100));

      // Search for "hoodie"
      final results = viewModel.search('hoodie');
      
      expect(results.isNotEmpty, true);
      expect(results.any((p) => p.title.toLowerCase().contains('hoodie')), true);
      
      // Search for nonsense
      final emptyResults = viewModel.search('XyZ_Not_Real');
      expect(emptyResults.isEmpty, true);
    });

    test('Search is case insensitive', () async {
      await Future.delayed(const Duration(milliseconds: 100));

      final lowerResults = viewModel.search('hoodie');
      final upperResults = viewModel.search('HOODIE');
      final mixedResults = viewModel.search('HoOdIe');
      
      expect(lowerResults.length, upperResults.length);
      expect(lowerResults.length, mixedResults.length);
    });

    // --- TEST 3: COLLECTION FILTERING (UPDATED FOR LIST) ---
    test('GetByCollection returns items containing that collection', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final clothing = viewModel.getByCollection('c_clothing');
      expect(clothing.isNotEmpty, true);
      
      // Each item should contain 'c_clothing' in its collectionIds list
      for (var item in clothing) {
        expect(item.collectionIds.contains('c_clothing'), true);
      }
    });

    test('Products can appear in multiple collections', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final clothing = viewModel.getByCollection('c_clothing');
      final signature = viewModel.getByCollection('c_signature');
      
      // Find products that are in both collections
      final inBoth = clothing.where((p) => 
        signature.any((s) => s.id == p.id)
      ).toList();
      
      // The Signature T-Shirt should be in both
      expect(inBoth.any((p) => p.id == 'p_signature'), true);
    });

    // --- TEST 4: SORTING ---
    test('GetByCollection sorts by price low to high', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final sorted = viewModel.getByCollection(
        'c_clothing',
        sortOption: SortOption.priceLowToHigh,
      );
      
      for (int i = 0; i < sorted.length - 1; i++) {
        expect(sorted[i].price <= sorted[i + 1].price, true);
      }
    });

    test('GetByCollection sorts by price high to low', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final sorted = viewModel.getByCollection(
        'c_clothing',
        sortOption: SortOption.priceHighToLow,
      );
      
      for (int i = 0; i < sorted.length - 1; i++) {
        expect(sorted[i].price >= sorted[i + 1].price, true);
      }
    });

    test('GetByCollection sorts by name A-Z', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final sorted = viewModel.getByCollection(
        'c_clothing',
        sortOption: SortOption.nameAZ,
      );
      
      for (int i = 0; i < sorted.length - 1; i++) {
        expect(sorted[i].title.compareTo(sorted[i + 1].title) <= 0, true);
      }
    });

    // --- TEST 5: PRICE FILTERING ---
    test('GetByCollection filters under £10', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final filtered = viewModel.getByCollection(
        'c_merch',
        priceRangeName: 'Under £10',
      );
      
      for (var item in filtered) {
        expect(item.price < 10.00, true);
      }
    });

    test('GetByCollection filters £10-£20', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final filtered = viewModel.getByCollection(
        'c_merch',
        priceRangeName: '£10 - £20',
      );
      
      for (var item in filtered) {
        expect(item.price >= 10.00 && item.price <= 20.00, true);
      }
    });

    test('GetByCollection filters over £20', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final filtered = viewModel.getByCollection(
        'c_clothing',
        priceRangeName: 'Over £20',
      );
      
      for (var item in filtered) {
        expect(item.price > 20.00, true);
      }
    });

    // --- TEST 6: SALE ITEMS ---
    test('GetSaleItems returns only discounted products', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final saleItems = viewModel.getSaleItems();
      expect(saleItems.isNotEmpty, true);
      
      for (var item in saleItems) {
        expect(item.oldPrice, isNotNull);
        expect(item.price < item.oldPrice!, true);
      }
    });
    
    // --- TEST 7: GET BY ID ---
    test('GetProductById returns correct product', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (viewModel.products.isEmpty) {
        fail('No products loaded, cannot test GetById');
      }
      
      final realProduct = viewModel.products.first;
      final realId = realProduct.id;

      final foundProduct = viewModel.getProductById(realId);
      
      expect(foundProduct.title, realProduct.title);
      expect(foundProduct.id, realId);
    });

    test('GetProductById with specific known ID', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final hoodie = viewModel.getProductById('p_classic_hoodie');
      
      expect(hoodie.title, 'Classic Hoodie');
      expect(hoodie.price, 25.00);
      expect(hoodie.oldPrice, 35.00);
    });

    // --- TEST 8: COMBINED SORT AND FILTER ---
    test('GetByCollection applies both sort and filter', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final result = viewModel.getByCollection(
        'c_merch',
        sortOption: SortOption.priceLowToHigh,
        priceRangeName: 'Under £10',
      );
      
      // Check filter
      for (var item in result) {
        expect(item.price < 10.00, true);
      }
      
      // Check sort
      for (int i = 0; i < result.length - 1; i++) {
        expect(result[i].price <= result[i + 1].price, true);
      }
    });

    // --- TEST 9: EMPTY COLLECTION ---
    test('GetByCollection returns empty for non-existent collection', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final result = viewModel.getByCollection('c_nonexistent');
      
      expect(result.isEmpty, true);
    });

    // --- TEST 10: ALL PRICES FILTER ---
    test('All Prices filter returns all items in collection', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final allPrices = viewModel.getByCollection(
        'c_clothing',
        priceRangeName: 'All Prices',
      );
      
      final noFilter = viewModel.getByCollection('c_clothing');
      
      expect(allPrices.length, noFilter.length);
    });
  });
}