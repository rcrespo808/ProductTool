import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/tag_repository.dart';

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
    // Load initial suggestions (most common tags) asynchronously
    updateQuery('');
  }

  /// Updates the search query and fetches suggestions asynchronously
  void updateQuery(String query) {
    // Update query immediately for responsive UI
    state = state.copyWith(query: query);

    // Fetch suggestions asynchronously
    _tagRepository.suggest(query).then((suggestions) {
      // Only update if query hasn't changed (avoid race conditions)
      if (state.query == query) {
        state = state.copyWith(suggestions: suggestions);
      }
    }).catchError((error) {
      // Handle errors silently, or could log in production
      // Keep current suggestions on error
    });
  }

  /// Clears the query and shows all tags
  void clearQuery() {
    updateQuery('');
  }
}

