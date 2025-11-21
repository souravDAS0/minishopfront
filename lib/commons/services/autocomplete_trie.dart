/// Trie Node representing each character in the Trie tree
class TrieNode {
  // Map of characters to child nodes
  Map<String, TrieNode> children = {};

  // Indicates if this node marks the end of a word
  bool isEndOfWord = false;

  // Stores the complete word at terminal nodes
  String? word;
}

/// Trie data structure for efficient autocomplete suggestions
/// Time Complexity: O(m) where m is the prefix length
class AutocompleteTrie {
  final TrieNode root = TrieNode();

  /// Insert a word into the Trie
  /// Time Complexity: O(n) where n is the word length
  void insert(String word) {
    if (word.isEmpty) return;

    // Convert to lowercase for case-insensitive search
    final lowercaseWord = word.toLowerCase();
    TrieNode current = root;

    // Traverse through each character
    for (int i = 0; i < lowercaseWord.length; i++) {
      final char = lowercaseWord[i];

      // Create new node if character doesn't exist
      if (!current.children.containsKey(char)) {
        current.children[char] = TrieNode();
      }

      // Move to next node
      current = current.children[char]!;
    }

    // Mark end of word and store the original word
    current.isEndOfWord = true;
    current.word = word;
  }

  /// Insert multiple words into the Trie
  void insertAll(List<String> words) {
    for (final word in words) {
      insert(word);
    }
  }

  /// Search for autocomplete suggestions based on prefix
  /// Returns maximum of maxSuggestions results
  /// Time Complexity: O(m + k) where m is prefix length, k is number of suggestions
  List<String> search(String prefix, {int maxSuggestions = 5}) {
    if (prefix.isEmpty) return [];

    final lowercasePrefix = prefix.toLowerCase();
    TrieNode? current = root;

    // Navigate to the prefix node
    for (int i = 0; i < lowercasePrefix.length; i++) {
      final char = lowercasePrefix[i];

      if (!current!.children.containsKey(char)) {
        // Prefix not found in Trie
        return [];
      }

      current = current.children[char];
    }

    // Collect all words with this prefix using DFS
    final suggestions = <String>[];
    _collectSuggestions(current, suggestions, maxSuggestions);

    return suggestions;
  }

  /// Helper method to collect suggestions using Depth-First Search
  /// Stops when maxSuggestions is reached
  void _collectSuggestions(
    TrieNode? node,
    List<String> suggestions,
    int maxSuggestions,
  ) {
    if (node == null || suggestions.length >= maxSuggestions) {
      return;
    }

    // If this node marks end of word, add it to suggestions
    if (node.isEndOfWord && node.word != null) {
      suggestions.add(node.word!);
      if (suggestions.length >= maxSuggestions) {
        return;
      }
    }

    // Recursively traverse all children
    for (final child in node.children.values) {
      _collectSuggestions(child, suggestions, maxSuggestions);
      if (suggestions.length >= maxSuggestions) {
        return;
      }
    }
  }

  /// Clear all words from the Trie
  void clear() {
    root.children.clear();
  }

  /// Get the total number of words in the Trie
  int get size {
    int count = 0;
    _countWords(root, (word) => count++);
    return count;
  }

  /// Helper method to count all words in the Trie
  void _countWords(TrieNode node, Function(String) callback) {
    if (node.isEndOfWord && node.word != null) {
      callback(node.word!);
    }

    for (final child in node.children.values) {
      _countWords(child, callback);
    }
  }
}
