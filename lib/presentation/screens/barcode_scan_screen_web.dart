import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Web stub for BarcodeScanScreenMobile
/// On web, we use manual entry (_WebBarcodeEntry) instead of camera scanning
/// This class exists only to satisfy conditional imports on web platform
/// It should never be instantiated since the wrapper uses _WebBarcodeEntry on web
class BarcodeScanScreenMobile extends ConsumerStatefulWidget {
  const BarcodeScanScreenMobile({super.key});

  @override
  ConsumerState<BarcodeScanScreenMobile> createState() =>
      _BarcodeScanScreenMobileState();
}

class _BarcodeScanScreenMobileState
    extends ConsumerState<BarcodeScanScreenMobile> {
  @override
  Widget build(BuildContext context) {
    // This should never be reached on web since BarcodeScannerWidget uses _WebBarcodeEntry
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(
        child: Text('Barcode scanner not available on web platform'),
      ),
    );
  }
}

