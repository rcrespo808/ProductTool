import 'dart:typed_data';
import 'local_storage_service.dart';
import '../util/result.dart';

/// Stub implementation (should not be used directly)
/// This is a fallback that should never be reached in practice
class LocalStorageServiceImpl implements LocalStorageService {
  @override
  Future<Result<String>> getImageDirectory() async {
    return const Failure('Storage service not available on this platform');
  }

  @override
  Future<Result<String>> saveImageBytes(
    Uint8List bytes, {
    required String fileName,
  }) async {
    return const Failure('Storage service not available on this platform');
  }
}

