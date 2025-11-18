import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import 'photo_capture_screen.dart';

/// Mobile implementation of barcode scanner using mobile_scanner
/// This file is only imported on non-web platforms
class BarcodeScanScreenMobile extends ConsumerStatefulWidget {
  const BarcodeScanScreenMobile({super.key});

  @override
  ConsumerState<BarcodeScanScreenMobile> createState() =>
      _BarcodeScanScreenMobileState();
}

class _BarcodeScanScreenMobileState
    extends ConsumerState<BarcodeScanScreenMobile> {
  MobileScannerController? _controller;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  void _startScanning() {
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
    _isScanning = true;
  }

  void _handleBarcodeDetected(String barcode) {
    if (!_isScanning) return;

    // Stop scanning
    _controller?.stop();
    _isScanning = false;

    // Start session
    ref.read(auditSessionProvider.notifier).startSession(barcode);

    // Navigate to photo capture screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const PhotoCaptureScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
      ),
      body: _controller != null
          ? Stack(
              children: [
                MobileScanner(
                  controller: _controller!,
                  onDetect: (capture) {
                    final barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty && mounted) {
                      final barcode = barcodes.first.rawValue;
                      if (barcode != null) {
                        _handleBarcodeDetected(barcode);
                      }
                    }
                  },
                ),
                // Overlay with instructions
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Point camera at product barcode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
