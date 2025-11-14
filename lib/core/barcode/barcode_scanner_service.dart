import '../util/result.dart';

/// Abstract interface for barcode scanning service
abstract class BarcodeScannerService {
  /// Starts scanning and streams detected barcodes
  Stream<Result<String>> startBarcodeStream();
  
  /// Stops scanning
  void stopScanning();
}

