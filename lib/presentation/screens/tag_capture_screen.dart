import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../../core/util/result.dart';
import '../../domain/models/file_naming.dart';
import '../widgets/tag_chip_cloud.dart';
import '../widgets/tag_autocomplete_input.dart';

class TagCaptureScreen extends ConsumerStatefulWidget {
  const TagCaptureScreen({super.key});

  @override
  ConsumerState<TagCaptureScreen> createState() => _TagCaptureScreenState();
}

class _TagCaptureScreenState extends ConsumerState<TagCaptureScreen> {
  final List<String> _selectedTags = [];

  /// Checks if a tag already exists (case-insensitive)
  bool _hasTag(List<String> tags, String newTag) {
    final normalized = FileNaming.normalizeTag(newTag);
    return tags.any((t) => FileNaming.normalizeTag(t) == normalized);
  }

  void _addTag(String tag) {
    setState(() {
      final normalizedTag = FileNaming.normalizeTag(tag);
      if (normalizedTag.isNotEmpty && !_hasTag(_selectedTags, normalizedTag)) {
        _selectedTags.add(normalizedTag);
      }
    });
  }

  void _removeTag(String tag) {
    setState(() {
      // Remove tag by normalized comparison
      final normalizedTag = FileNaming.normalizeTag(tag);
      _selectedTags.removeWhere((t) => FileNaming.normalizeTag(t) == normalizedTag);
    });
  }

  void _toggleTag(String tag) {
    if (_hasTag(_selectedTags, tag)) {
      _removeTag(tag);
    } else {
      _addTag(tag);
    }
  }

  /// Saves tags to repository without capturing photo
  Future<void> _saveTags() async {
    if (_selectedTags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No tags to save')),
      );
      return;
    }

    final tagRepo = ref.read(tagRepositoryProvider);
    final result = await tagRepo.registerTags(_selectedTags);

    if (mounted) {
      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tags saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.errorMessage ?? 'Error saving tags',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _capturePhoto() async {
    final notifier = ref.read(auditSessionProvider.notifier);
    await notifier.captureTaggedPhoto(_selectedTags);

    if (mounted) {
      final state = ref.read(auditSessionProvider);
      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error!)),
        );
      } else {
        // Clear selected tags after successful capture
        setState(() {
          _selectedTags.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo captured and saved'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _finishSession() {
    final notifier = ref.read(auditSessionProvider.notifier);
    final state = ref.read(auditSessionProvider);

    if (state.session?.imageCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture at least one photo before finishing'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finish Session'),
        content: Text(
          'Session completed with ${state.imageCount} photo(s). '
          'You can now start a new session.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              notifier.clearSession();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(auditSessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode: ${sessionState.barcode ?? 'Unknown'}'),
        actions: [
          TextButton.icon(
            onPressed: _finishSession,
            icon: const Icon(Icons.check),
            label: const Text('Finish'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
      body: sessionState.session == null
          ? const Center(child: Text('No active session'))
          : Column(
              children: [
                // Session info
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _InfoChip(
                        icon: Icons.qr_code,
                        label: 'Barcode',
                        value: sessionState.barcode ?? 'Unknown',
                      ),
                      _InfoChip(
                        icon: Icons.photo_library,
                        label: 'Photos',
                        value: '${sessionState.imageCount}',
                      ),
                    ],
                  ),
                ),

                // Tag autocomplete input
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TagAutocompleteInput(
                    onTagAdded: _addTag,
                    existingTags: _selectedTags,
                  ),
                ),

                // Selected tags
                if (_selectedTags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Tags:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedTags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              onDeleted: () => _removeTag(tag),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                // Tag chip cloud
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Suggestions:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TagChipCloud(
                          selectedTags: _selectedTags,
                          onTagTap: _toggleTag,
                        ),
                      ],
                    ),
                  ),
                ),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Save Tags button (if tags are selected)
                      if (_selectedTags.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: sessionState.isLoading ? null : _saveTags,
                              icon: const Icon(Icons.save),
                              label: const Text('Save Tags'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ),
                      // Capture Photo button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed:
                              sessionState.isLoading ? null : _capturePhoto,
                          icon: sessionState.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.camera_alt),
                          label: Text(
                            sessionState.isLoading
                                ? 'Capturing...'
                                : 'Capture Photo',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

