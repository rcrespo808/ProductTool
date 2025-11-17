import 'package:flutter/material.dart';

/// Widget that displays action buttons for saving tags and capturing photos
class TagActionButtons extends StatelessWidget {
  final List<String> selectedTags;
  final bool isLoading;
  final VoidCallback onSaveTags;
  final VoidCallback onCapturePhoto;

  const TagActionButtons({
    super.key,
    required this.selectedTags,
    required this.isLoading,
    required this.onSaveTags,
    required this.onCapturePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Save Tags button (if tags are selected)
          if (selectedTags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : onSaveTags,
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
              onPressed: isLoading ? null : onCapturePhoto,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.camera_alt),
              label: Text(
                isLoading ? 'Capturing...' : 'Capture Photo',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

