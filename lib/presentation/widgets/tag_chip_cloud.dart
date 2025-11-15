import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';

/// Widget that displays tags as chips in a cloud layout
/// Tags are sized by usage frequency
class TagChipCloud extends ConsumerWidget {
  final List<String> selectedTags;
  final Function(String tag) onTagTap;

  const TagChipCloud({
    super.key,
    required this.selectedTags,
    required this.onTagTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionsState = ref.watch(tagSuggestionsProvider);
    final suggestions = suggestionsState.suggestions;

    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: suggestions.map((suggestion) {
        final isSelected = selectedTags.contains(suggestion.tag);
        // Scale font size based on usage count (min 12, max 18)
        final fontSize = 12.0 + (suggestion.usageCount * 0.5).clamp(0.0, 6.0);

        return FilterChip(
          label: Text(
            suggestion.tag,
            style: TextStyle(
              fontSize: fontSize,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          selected: isSelected,
          onSelected: (_) => onTagTap(suggestion.tag),
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
        );
      }).toList(),
    );
  }
}

