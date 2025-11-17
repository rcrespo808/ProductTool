import 'dart:async';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'barcode_scanner_service.dart';
import '../../utils/result.dart';

/// Implementation of BarcodeScannerService using mobile_scanner
class BarcodeScannerImpl implements BarcodeScannerService {
  MobileScannerController? _controller;
  final _barcodeController = StreamController<Result<String>>();
  bool _isScanning = false;

  @override
  Stream<Result<String>> startBarcodeStream() {
    if (_isScanning) {
      return _barcodeController.stream;
    }

    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );

    // Note: In mobile_scanner 5.x, barcode detection is handled via MobileScanner widget's onDetect callback
    // This service provides a stream interface, but the actual scanning UI uses MobileScanner widget directly
    // For now, return an empty stream that can be used if needed
    // The barcode scanning is handled in barcode_scan_screen_mobile.dart using MobileScanner widget

    _isScanning = true;
    return _barcodeController.stream;
  }

  @override
  void stopScanning() {
    _controller?.dispose();
    _controller = null;
    _isScanning = false;
  }

  /// Gets the scanner controller for UI integration
  MobileScannerController? get controller => _controller;
}

