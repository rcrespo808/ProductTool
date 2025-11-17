import 'dart:typed_data';
import '../../utils/result.dart';

/// Abstract interface for local file storage
abstract class LocalStorageService {
  /// Saves image bytes to a file with the given fileName
  /// Returns the full path to the saved file
  Future<Result<String>> saveImageBytes(
    Uint8List bytes, {
    required String fileName,
  });

  /// Gets the directory path where images should be saved
  Future<Result<String>> getImageDirectory();
}

