import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../utils/result.dart';
import '../widgets/components/session_info_bar.dart';
import 'barcode_scan_screen.dart';

class PhotoCaptureScreen extends ConsumerStatefulWidget {
  const PhotoCaptureScreen({super.key});

  @override
  ConsumerState<PhotoCaptureScreen> createState() => _PhotoCaptureScreenState();
}

class _PhotoCaptureScreenState extends ConsumerState<PhotoCaptureScreen> {
  Future<void> _capturePhoto() async {
    final notifier = ref.read(auditSessionProvider.notifier);
    await notifier.capturePhoto();

    if (mounted) {
      final state = ref.read(auditSessionProvider);
      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error!)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo captured and saved'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _finishSession() async {
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

    // Show loading indicator
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Finishing session...'),
          duration: Duration(seconds: 1),
        ),
      );
    }

    final result = await notifier.finishSession();

    if (!mounted) return;

    if (result.isFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'Failed to finish session'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Success - show confirmation with option to start next audit
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            const SizedBox(width: 8),
            const Text('Audit Completed'),
          ],
        ),
        content: Text(
          'Session completed with ${state.imageCount} photo(s).\n\n'
          'The session has been saved. You can now start auditing the next product.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate back to home and refresh the list
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Back to Home'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
              // Navigate to barcode scan after a short delay to allow dialog to close
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BarcodeScanScreen(),
                    ),
                  );
                }
              });
            },
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Start Next Audit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          // Finish Audit button with proper contrast
          if (sessionState.imageCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextButton.icon(
                onPressed: sessionState.isLoading ? null : _finishSession,
                icon: const Icon(Icons.check_circle),
                label: const Text('Finish Audit'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  // Add subtle background for extra contrast
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .onPrimary
                      .withOpacity(0.1),
                ),
              ),
            ),
        ],
      ),
      body: sessionState.session == null
          ? Center(
              child: Text(
                'No active session',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            )
          : Column(
              children: [
                // Session info
                SessionInfoBar(
                  barcode: sessionState.barcode,
                  imageCount: sessionState.imageCount,
                ),

                // Photo list/counter
                Expanded(
                  child: sessionState.imageCount == 0
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_library,
                                size: 64,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No photos captured yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: sessionState.imageCount,
                          itemBuilder: (context, index) {
                            final image =
                                sessionState.session!.images[index];
                            return ListTile(
                              leading: const Icon(Icons.image),
                              title: Text(image.fileName),
                              subtitle: Text(image.localPath),
                            );
                          },
                        ),
                ),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Capture button
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
                      
                      // Finish Audit button (only show if photos exist)
                      if (sessionState.imageCount > 0) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: sessionState.isLoading ? null : _finishSession,
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Finish Audit'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              foregroundColor: Colors.green,
                              side: const BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

