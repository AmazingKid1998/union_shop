import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';

void main() {
  late ShopViewModel viewModel;

  setUp(() {
    viewModel = ShopViewModel();
  });

  group('ShopViewModel Tests', () {
    test('Initial products are loaded', () async {
      // Allow the async constructor/method to complete
      await Future.delayed(const Duration(milliseconds: 100));
      expect(viewModel.products, isNotEmpty);
    });

    test('getByCollection filters by price correctly', () {
      // Test "Under £10"
      final cheapItems = viewModel.getByCollection(
        'c_merch', 
        priceRangeName: 'Under £10'
      );

      for (var item in cheapItems) {
        expect(item.price, lessThan(10.0));
      }
    });

    test('getByCollection sorts by price Low to High', () {
      final items = viewModel.getByCollection(
        'c_clothing', 
        sortOption: SortOption.priceLowToHigh
      );

      for (int i = 0; i < items.length - 1; i++) {
        expect(items[i].price, lessThanOrEqualTo(items[i + 1].price));
      }
    });

    test('search returns matching titles', () {
      // Assuming we have data loaded
      // (You might need to wait or mock if data loading was slower, 
      // but for static repo it's instant usually)
       
      // Trigger a load explicitly if needed or wait
      final results = viewModel.search('Hoodie');
      expect(results, isNotEmpty);
      expect(results.first.title, contains('Hoodie'));
    });
  });
}