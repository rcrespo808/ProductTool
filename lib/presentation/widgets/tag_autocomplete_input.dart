import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';

/// Widget that provides autocomplete for tag input
class TagAutocompleteInput extends ConsumerStatefulWidget {
  final Function(String tag) onTagAdded;
  final List<String> existingTags;

  const TagAutocompleteInput({
    super.key,
    required this.onTagAdded,
    this.existingTags = const [],
  });

  @override
  ConsumerState<TagAutocompleteInput> createState() =>
      _TagAutocompleteInputState();
}

class _TagAutocompleteInputState extends ConsumerState<TagAutocompleteInput> {
  @override
  Widget build(BuildContext context) {
    final suggestionsState = ref.watch(tagSuggestionsProvider);

    return Autocomplete<String>(
      fieldViewBuilder: (
        context,
        textEditingController,
        focusNode,
        onFieldSubmitted,
      ) {
        // Update suggestions when text changes
        // Note: This listener may be added multiple times during rebuilds,
        // but that's okay as it's cheap and ensures suggestions are updated
        textEditingController.addListener(() {
          ref.read(tagSuggestionsProvider.notifier).updateQuery(
                textEditingController.text,
              );
        });

        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Add tag',
            hintText: 'Type to search or add new tag',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            onFieldSubmitted();
            if (value.trim().isNotEmpty &&
                !widget.existingTags.contains(value.trim())) {
              widget.onTagAdded(value.trim());
              textEditingController.clear();
              ref.read(tagSuggestionsProvider.notifier).updateQuery('');
            }
          },
        );
      },
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          // Show most common tags when empty
          return suggestionsState.suggestions
              .take(10)
              .map((s) => s.tag)
              .where((tag) => !widget.existingTags.contains(tag));
        }

        // Show matching suggestions
        return suggestionsState.suggestions
            .where((s) => s.tag
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()))
            .map((s) => s.tag)
            .where((tag) => !widget.existingTags.contains(tag));
      },
      onSelected: (option) {
        // Tag was selected from suggestions
        widget.onTagAdded(option.trim());
        // Clear the autocomplete field by finding the TextField and clearing it
        // This will be handled by the parent widget refreshing
      },
      displayStringForOption: (option) => option,
    );
  }
}
