import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minishopfront/commons/notifiers/search_notifier.dart';
import '../services/autocomplete_trie.dart';

// Provider for AutocompleteTrie
final autocompleteTrieProvider = Provider<AutocompleteTrie>((ref) {
  return AutocompleteTrie();
});

// Provider for SearchNotifier
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  final trie = ref.watch(autocompleteTrieProvider);
  return SearchNotifier(trie, ref);
});
