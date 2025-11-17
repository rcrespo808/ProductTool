import 'package:flutter/material.dart';

/// Widget that displays selected tags as removable chips
class SelectedTagsSection extends StatelessWidget {
  final List<String> tags;
  final Function(String tag) onTagRemoved;

  const SelectedTagsSection({
    super.key,
    required this.tags,
    required this.onTagRemoved,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Tags:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              return Chip(
                label: Text(tag),
                onDeleted: () => onTagRemoved(tag),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

