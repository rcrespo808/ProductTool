import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/tags/tag_repository.dart';

/// State for tag suggestions
class TagSuggestionsState {
  final List<({String tag, int usageCount})> suggestions;
  final String query;

  const TagSuggestionsState({
    this.suggestions = const [],
    this.query = '',
  });

  TagSuggestionsState copyWith({
    List<({String tag, int usageCount})>? suggestions,
    String? query,
  }) =>
      TagSuggestionsState(
        suggestions: suggestions ?? this.suggestions,
        query: query ?? this.query,
      );
}

/// Notifier for managing tag suggestions
class TagSuggestionsNotifier extends StateNotifier<TagSuggestionsState> {
  final TagRepository _tagRepository;

  TagSuggestionsNotifier(this._tagRepository)
      : super(const TagSuggestionsState()) {
    // Load initial suggestions (most common tags)
    updateQuery('');
  }

  /// Updates the search query and fetches suggestions
  void updateQuery(String query) {
    final suggestions = _tagRepository.suggest(query);
    state = state.copyWith(
      query: query,
      suggestions: suggestions,
    );
  }

  /// Clears the query and shows all tags
  void clearQuery() {
    updateQuery('');
  }
}

