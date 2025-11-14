/// Node in the tag trie data structure
class TrieNode {
  final Map<String, TrieNode> children;
  int usageCount;
  bool isEndOfWord;

  TrieNode({
    Map<String, TrieNode>? children,
    this.usageCount = 0,
    this.isEndOfWord = false,
  }) : children = children ?? {};

  /// Serializes the trie node to JSON
  Map<String, dynamic> toJson() => {
        'children': children.map(
          (key, value) => MapEntry(key, value.toJson()),
        ),
        'usageCount': usageCount,
        'isEndOfWord': isEndOfWord,
      };

  /// Deserializes a trie node from JSON
  factory TrieNode.fromJson(Map<String, dynamic> json) => TrieNode(
        children: (json['children'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(
            key,
            TrieNode.fromJson(value as Map<String, dynamic>),
          ),
        ),
        usageCount: json['usageCount'] as int? ?? 0,
        isEndOfWord: json['isEndOfWord'] as bool? ?? false,
      );
}

/// Trie data structure for storing tags with prefix matching and usage tracking
class TagTrie {
  final TrieNode root;

  TagTrie() : root = TrieNode();

  /// Inserts a tag into the trie
  /// If the tag already exists, increments its usage count
  void insert(String tag) {
    final sanitized = tag.toLowerCase().trim();
    if (sanitized.isEmpty) return;

    TrieNode current = root;
    for (final char in sanitized.runes) {
      final charStr = String.fromCharCode(char);
      current.children[charStr] ??= TrieNode();
      current = current.children[charStr]!;
    }
    current.isEndOfWord = true;
    current.usageCount++;
  }

  /// Finds a tag in the trie and returns its usage count
  int getUsageCount(String tag) {
    final sanitized = tag.toLowerCase().trim();
    TrieNode? current = root;
    for (final char in sanitized.runes) {
      final charStr = String.fromCharCode(char);
      current = current.children[charStr];
      if (current == null) return 0;
    }
    return current.isEndOfWord ? current.usageCount : 0;
  }

  /// Suggests tags that match the given prefix
  /// Returns a list of (tag, usageCount) pairs, sorted by usage count (descending)
  List<({String tag, int usageCount})> suggest(String prefix) {
    final sanitized = prefix.toLowerCase().trim();
    TrieNode? current = root;

    // Navigate to the prefix node
    for (final char in sanitized.runes) {
      final charStr = String.fromCharCode(char);
      current = current.children[charStr];
      if (current == null) return [];
    }

    // Collect all words from this node
    final suggestions = <({String tag, int usageCount})>[];
    _collectWords(current!, sanitized, suggestions);
    suggestions.sort((a, b) => b.usageCount.compareTo(a.usageCount));
    return suggestions;
  }

  /// Recursively collects all words from a node
  void _collectWords(
    TrieNode node,
    String prefix,
    List<({String tag, int usageCount})> results,
  ) {
    if (node.isEndOfWord) {
      results.add((tag: prefix, usageCount: node.usageCount));
    }
    for (final entry in node.children.entries) {
      _collectWords(entry.value, prefix + entry.key, results);
    }
  }

  /// Gets all tags with their usage counts, sorted by usage (descending)
  List<({String tag, int usageCount})> getAllTags() {
    return suggest('');
  }

  /// Serializes the trie to JSON
  Map<String, dynamic> toJson() => root.toJson();

  /// Deserializes the trie from JSON
  factory TagTrie.fromJson(Map<String, dynamic> json) {
    final trie = TagTrie();
    trie.root.children.clear();
    trie.root.children.addAll(
      (json['children'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(
          key,
          TrieNode.fromJson(value as Map<String, dynamic>),
        ),
      ),
    );
    trie.root.usageCount = json['usageCount'] as int? ?? 0;
    trie.root.isEndOfWord = json['isEndOfWord'] as bool? ?? false;
    return trie;
  }
}

