import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'tag_trie.dart';

/// Repository for managing tag persistence and retrieval
abstract class TagRepository {
  /// Loads tags from persistent storage
  Future<void> load();

  /// Saves tags to persistent storage
  Future<void> save();

  /// Registers one or more tags (increments usage count)
  Future<void> registerTags(List<String> tags);

  /// Suggests tags matching the given prefix
  List<({String tag, int usageCount})> suggest(String prefix);

  /// Gets all tags sorted by usage count
  List<({String tag, int usageCount})> getAllTags();
}

/// Implementation of TagRepository using SharedPreferences
class TagRepositoryImpl implements TagRepository {
  static const String _storageKey = 'tag_trie';
  final TagTrie _trie = TagTrie();
  bool _loaded = false;

  @override
  Future<void> load() async {
    if (_loaded) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final loadedTrie = TagTrie.fromJson(json);
        // Replace the root's children with loaded data
        _trie.root.children.clear();
        _trie.root.children.addAll(loadedTrie.root.children);
        _trie.root.usageCount = loadedTrie.root.usageCount;
        _trie.root.isEndOfWord = loadedTrie.root.isEndOfWord;
      }
      _loaded = true;
    } catch (e) {
      // If loading fails, start with empty trie
      _loaded = true;
    }
  }

  @override
  Future<void> save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = _trie.toJson();
      final jsonString = jsonEncode(json);
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      // Silently fail - could log in production
    }
  }

  @override
  Future<void> registerTags(List<String> tags) async {
    await load();
    for (final tag in tags) {
      if (tag.trim().isNotEmpty) {
        _trie.insert(tag);
      }
    }
    await save();
  }

  @override
  List<({String tag, int usageCount})> suggest(String prefix) {
    if (!_loaded) {
      load(); // Try to load, but don't wait
      return [];
    }
    if (prefix.isEmpty) {
      return _trie.getAllTags();
    }
    return _trie.suggest(prefix);
  }

  @override
  List<({String tag, int usageCount})> getAllTags() {
    if (!_loaded) {
      load();
      return [];
    }
    return _trie.getAllTags();
  }

}

