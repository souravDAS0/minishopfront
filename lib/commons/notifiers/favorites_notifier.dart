import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minishopfront/commons/services/hive_service.dart';

class FavoritesState {
  final Set<int> favoriteIds;

  FavoritesState({Set<int>? favoriteIds}) : favoriteIds = favoriteIds ?? {};

  FavoritesState copyWith({Set<int>? favoriteIds}) {
    return FavoritesState(favoriteIds: favoriteIds ?? this.favoriteIds);
  }
}

// Favorites StateNotifier
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final HiveService _hiveService;

  FavoritesNotifier(this._hiveService) : super(FavoritesState()) {
    _loadFavorites();
  }

  // Load favorites from Hive on initialization
  void _loadFavorites() {
    try {
      final favoriteIds = _hiveService.getFavoriteIds();
      state = state.copyWith(favoriteIds: favoriteIds.toSet());
    } catch (e) {
      // If Hive is not initialized yet, favorites will be empty
      state = state.copyWith(favoriteIds: {});
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(int productId) async {
    try {
      final isFavorite = await _hiveService.toggleFavorite(productId);

      final updatedFavorites = Set<int>.from(state.favoriteIds);
      if (isFavorite) {
        updatedFavorites.add(productId);
      } else {
        updatedFavorites.remove(productId);
      }

      state = state.copyWith(favoriteIds: updatedFavorites);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
