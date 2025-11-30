import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CameraAccess extends GetxController {
  static CameraAccess get instace => Get.find();

  Future<void> GetCameraAccess() async {
    final ImagePicker PickImage = ImagePicker();
    final XFile? image = await PickImage.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
  }
}
