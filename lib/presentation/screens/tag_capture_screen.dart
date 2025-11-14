import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../../application/audit/audit_session_notifier.dart';
import '../widgets/tag_chip_cloud.dart';
import '../widgets/tag_autocomplete_input.dart';

class TagCaptureScreen extends ConsumerStatefulWidget {
  const TagCaptureScreen({super.key});

  @override
  ConsumerState<TagCaptureScreen> createState() => _TagCaptureScreenState();
}

class _TagCaptureScreenState extends ConsumerState<TagCaptureScreen> {
  final List<String> _selectedTags = [];

  void _addTag(String tag) {
    setState(() {
      if (!_selectedTags.contains(tag)) {
        _selectedTags.add(tag);
      }
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
  }

  void _toggleTag(String tag) {
    if (_selectedTags.contains(tag)) {
      _removeTag(tag);
    } else {
      _addTag(tag);
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
                  color: Theme.of(context).colorScheme.surfaceVariant,
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

                // Capture button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
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

