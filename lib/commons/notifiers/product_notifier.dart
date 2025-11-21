import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minishopfront/commons/models/product.dart';
import 'package:minishopfront/commons/services/api_service.dart';

// Enum for sort options
enum SortOption { none, priceLowToHigh, priceHighToLow }

class ProductState {
  final List<Product> products;
  final bool isLoading;
  final String? error;
  final SortOption sortOption;

  ProductState({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.sortOption = SortOption.none,
  });

  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
    SortOption? sortOption,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  // Get sorted products based on current sort option
  List<Product> get sortedProducts {
    final productsCopy = List<Product>.from(products);

    switch (sortOption) {
      case SortOption.priceLowToHigh:
        productsCopy.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighToLow:
        productsCopy.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.none:
        // Return original order
        break;
    }

    return productsCopy;
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  final ApiService _apiService;

  ProductNotifier(this._apiService) : super(ProductState());

  // Load products from API
  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final products = await _apiService.getProducts();
      state = state.copyWith(products: products, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await loadProducts();
  }

  // Set sort option
  void setSortOption(SortOption option) {
    state = state.copyWith(sortOption: option);
  }
}
