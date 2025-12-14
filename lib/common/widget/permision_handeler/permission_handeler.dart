import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandeler extends GetxController {
  static PermissionHandeler get instance => Get.find();

  Future<void> permissionHandle() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.notification,
    ].request();
  }
}
