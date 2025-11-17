import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/tags/tag_trie.dart';
import '../../utils/result.dart';

/// Repository for managing tag persistence and retrieval
abstract class TagRepository {
  /// Loads tags from persistent storage
  /// Returns Success if loaded successfully, Failure if error occurs
  Future<Result<void>> load();

  /// Saves tags to persistent storage
  /// Returns Success if saved successfully, Failure if error occurs
  Future<Result<void>> save();

  /// Registers one or more tags (increments usage count)
  /// Returns Success if registered successfully, Failure if error occurs
  Future<Result<void>> registerTags(List<String> tags);

  /// Suggests tags matching the given prefix
  /// Ensures data is loaded before suggesting
  Future<List<({String tag, int usageCount})>> suggest(String prefix);

  /// Gets all tags sorted by usage count
  /// Ensures data is loaded before returning
  Future<List<({String tag, int usageCount})>> getAllTags();
}

/// Implementation of TagRepository using SharedPreferences
class TagRepositoryImpl implements TagRepository {
  static const String _storageKey = 'tag_trie';
  final TagTrie _trie = TagTrie();
  bool _loaded = false;

  @override
  Future<Result<void>> load() async {
    if (_loaded) return const Success(null);

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          final loadedTrie = TagTrie.fromJson(json);
          // Replace the root's children with loaded data
          _trie.root.children.clear();
          _trie.root.children.addAll(loadedTrie.root.children);
          _trie.root.usageCount = loadedTrie.root.usageCount;
          _trie.root.isEndOfWord = loadedTrie.root.isEndOfWord;
        } catch (e) {
          // JSON decode or trie deserialization failed
          // Start with empty trie but report error
          _loaded = true;
          return Failure(
            'Failed to parse saved tags: ${e.toString()}. Starting with empty tag list.',
            e,
          );
        }
      }
      _loaded = true;
      return const Success(null);
    } catch (e) {
      // SharedPreferences access failed
      _loaded = true;
      return Failure(
        'Failed to load tags: ${e.toString()}. Starting with empty tag list.',
        e,
      );
    }
  }

  @override
  Future<Result<void>> save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = _trie.toJson();
      final jsonString = jsonEncode(json);
      await prefs.setString(_storageKey, jsonString);
      return const Success(null);
    } catch (e) {
      return Failure(
        'Failed to save tags: ${e.toString()}',
        e,
      );
    }
  }

  @override
  Future<Result<void>> registerTags(List<String> tags) async {
    final loadResult = await load();
    if (loadResult.isFailure) {
      // If load failed, still try to add tags to memory (they'll be lost on restart, but better than nothing)
      // Continue execution but note that persistence might fail
    }

    for (final tag in tags) {
      if (tag.trim().isNotEmpty) {
        _trie.insert(tag);
      }
    }

    final saveResult = await save();
    return saveResult;
  }

  @override
  Future<List<({String tag, int usageCount})>> suggest(String prefix) async {
    // Load tags (ignore errors - will return empty suggestions if load failed)
    await load();
    if (prefix.isEmpty) {
      return _trie.getAllTags();
    }
    return _trie.suggest(prefix);
  }

  @override
  Future<List<({String tag, int usageCount})>> getAllTags() async {
    // Load tags (ignore errors - will return empty list if load failed)
    await load();
    return _trie.getAllTags();
  }
}

