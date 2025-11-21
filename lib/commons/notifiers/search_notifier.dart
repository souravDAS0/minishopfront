import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minishopfront/commons/models/product.dart';
import 'package:minishopfront/commons/providers/product_provider.dart';
import 'package:minishopfront/commons/services/autocomplete_trie.dart';

class SearchState {
  final String query;
  final List<String> suggestions;
  final List<Product> searchResults;

  SearchState({
    this.query = '',
    this.suggestions = const [],
    this.searchResults = const [],
  });

  SearchState copyWith({
    String? query,
    List<String>? suggestions,
    List<Product>? searchResults,
  }) {
    return SearchState(
      query: query ?? this.query,
      suggestions: suggestions ?? this.suggestions,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}

// Search StateNotifier
class SearchNotifier extends StateNotifier<SearchState> {
  final AutocompleteTrie _trie;
  final Ref _ref;

  SearchNotifier(this._trie, this._ref) : super(SearchState());

  // Initialize Trie with product names
  void initializeTrie(List<Product> products) {
    _trie.clear();
    final productNames = products.map((p) => p.name).toList();
    _trie.insertAll(productNames);
  }

  // Update search query and get suggestions
  void updateQuery(String query) {
    if (query.isEmpty) {
      state = SearchState();
      return;
    }

    // Get autocomplete suggestions (max 5)
    final suggestions = _trie.search(query, maxSuggestions: 5);

    // Get search results from products
    final products = _ref.read(productProvider).products;
    final searchResults = products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    state = state.copyWith(
      query: query,
      suggestions: suggestions,
      searchResults: searchResults,
    );
  }

  // Clear search
  void clearSearch() {
    state = SearchState();
  }
}
