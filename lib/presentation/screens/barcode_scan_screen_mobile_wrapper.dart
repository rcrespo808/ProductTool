import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import 'photo_capture_screen.dart';

// Import mobile implementation only on non-web platforms
import 'barcode_scan_screen_mobile.dart'
    if (dart.library.html) 'barcode_scan_screen_web.dart';

/// Wrapper that returns the appropriate barcode scanner widget based on platform
class BarcodeScannerWidget extends ConsumerWidget {
  const BarcodeScannerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb) {
      // Web: manual entry
      return const _WebBarcodeEntry();
    } else {
      // Mobile: camera scanner
      return const BarcodeScanScreenMobile();
    }
  }
}

/// Web implementation: manual barcode entry
class _WebBarcodeEntry extends ConsumerStatefulWidget {
  const _WebBarcodeEntry();

  @override
  ConsumerState<_WebBarcodeEntry> createState() => _WebBarcodeEntryState();
}

class _WebBarcodeEntryState extends ConsumerState<_WebBarcodeEntry> {
  final _controller = TextEditingController();

  void _handleSubmit(String barcode) {
    if (barcode.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a barcode')),
      );
      return;
    }

    ref.read(auditSessionProvider.notifier).startSession(barcode.trim());

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PhotoCaptureScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Barcode')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Barcode Scanner',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Web platform does not support camera barcode scanning.\nPlease enter the barcode manually.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Barcode',
                hintText: 'Enter product barcode',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.qr_code_scanner),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSubmitted: _handleSubmit,
              autofocus: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _handleSubmit(_controller.text),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Continue'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
