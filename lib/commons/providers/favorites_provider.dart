import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minishopfront/commons/notifiers/favorites_notifier.dart';
import '../services/hive_service.dart';

// Provider for HiveService
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

// Provider for FavoritesNotifier
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
      final hiveService = ref.watch(hiveServiceProvider);
      return FavoritesNotifier(hiveService);
    });
