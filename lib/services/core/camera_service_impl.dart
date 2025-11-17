import 'package:image_picker/image_picker.dart';
import 'camera_service.dart';
import '../../utils/result.dart';

/// Implementation of CameraService using image_picker
class CameraServiceImpl implements CameraService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<Result<XFile>> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image == null) {
        return const Failure('Photo capture cancelled');
      }

      return Success(image);
    } catch (e) {
      return Failure('Failed to capture photo: ${e.toString()}', e);
    }
  }
}

