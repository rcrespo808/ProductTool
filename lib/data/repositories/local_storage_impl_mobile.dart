import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'local_storage_service.dart';
import '../../utils/result.dart';

/// Mobile implementation of LocalStorageService using path_provider
/// For Android and iOS platforms
class LocalStorageServiceImpl implements LocalStorageService {
  String? _cachedDirectory;

  @override
  Future<Result<String>> getImageDirectory() async {
    if (_cachedDirectory != null) {
      return Success(_cachedDirectory!);
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final imageDir = Directory(path.join(directory.path, 'audit_images'));

      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      _cachedDirectory = imageDir.path;
      return Success(imageDir.path);
    } catch (e) {
      return Failure('Failed to get image directory: ${e.toString()}', e);
    }
  }

  @override
  Future<Result<String>> saveImageBytes(
    Uint8List bytes, {
    required String fileName,
  }) async {
    try {
      final dirResult = await getImageDirectory();
      if (dirResult.isFailure) {
        return dirResult.map((_) => '');
      }

      final dir = dirResult.valueOrNull!;
      final file = File(path.join(dir, fileName));

      await file.writeAsBytes(bytes);

      return Success(file.path);
    } catch (e) {
      return Failure(
        'Failed to save image: ${e.toString()}',
        e,
      );
    }
  }
}

