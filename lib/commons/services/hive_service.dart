import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;

  HiveService._internal();

  static const String _favoritesBoxName = 'favorites';
  Box<int>? _favoritesBox;

  // Initialize Hive
  Future<void> init() async {
    await Hive.initFlutter();
    _favoritesBox = await Hive.openBox<int>(_favoritesBoxName);
  }

  // Get all favorite product IDs
  List<int> getFavoriteIds() {
    if (_favoritesBox == null) {
      throw Exception('Hive not initialized. Call init() first.');
    }
    return _favoritesBox!.values.toList();
  }

  // Check if a product is favorited
  bool isFavorite(int productId) {
    if (_favoritesBox == null) {
      throw Exception('Hive not initialized. Call init() first.');
    }
    return _favoritesBox!.values.contains(productId);
  }

  // Add a product to favorites
  Future<void> addFavorite(int productId) async {
    if (_favoritesBox == null) {
      throw Exception('Hive not initialized. Call init() first.');
    }
    if (!isFavorite(productId)) {
      await _favoritesBox!.add(productId);
    }
  }

  // Remove a product from favorites
  Future<void> removeFavorite(int productId) async {
    if (_favoritesBox == null) {
      throw Exception('Hive not initialized. Call init() first.');
    }

    // Find the key for this product ID
    final key = _favoritesBox!.keys.firstWhere(
      (key) => _favoritesBox!.get(key) == productId,
      orElse: () => null,
    );

    if (key != null) {
      await _favoritesBox!.delete(key);
    }
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(int productId) async {
    if (isFavorite(productId)) {
      await removeFavorite(productId);
      return false;
    } else {
      await addFavorite(productId);
      return true;
    }
  }

  // Close Hive box (call when app is closing)
  Future<void> close() async {
    await _favoritesBox?.close();
  }
}
