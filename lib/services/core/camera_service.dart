import 'package:image_picker/image_picker.dart';
import '../../utils/result.dart';

/// Abstract interface for camera/photo capture service
abstract class CameraService {
  /// Takes a photo and returns the file, or null if cancelled
  Future<Result<XFile>> takePhoto();
}

