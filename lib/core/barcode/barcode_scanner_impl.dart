import 'dart:async';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'barcode_scanner_service.dart';
import '../util/result.dart';

/// Implementation of BarcodeScannerService using mobile_scanner
class BarcodeScannerImpl implements BarcodeScannerService {
  MobileScannerController? _controller;
  StreamSubscription<BarcodeCapture>? _subscription;
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

    _subscription = _controller!.barcodeCapture.listen((capture) {
      final barcodes = capture.barcodes;
      if (barcodes.isNotEmpty) {
        final barcode = barcodes.first;
        if (barcode.rawValue != null) {
          _barcodeController.add(Success(barcode.rawValue!));
        }
      }
    });

    _isScanning = true;
    return _barcodeController.stream;
  }

  @override
  void stopScanning() {
    _subscription?.cancel();
    _controller?.dispose();
    _controller = null;
    _isScanning = false;
  }

  /// Gets the scanner controller for UI integration
  MobileScannerController? get controller => _controller;
}

