import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minishopfront/commons/notifiers/product_notifier.dart';
import '../services/api_service.dart';

// Provider for ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Provider for ProductNotifier
final productProvider =
    StateNotifierProvider.autoDispose<ProductNotifier, ProductState>((ref) {
      final apiService = ref.watch(apiServiceProvider);
      return ProductNotifier(apiService);
    });
