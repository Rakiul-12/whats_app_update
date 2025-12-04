import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whats_app/data/repository/user/UserRepository.dart';
import 'package:whats_app/data/repository/authentication_repo/AuthenticationRepo.dart';
import 'package:whats_app/feature/personalization/controller/UserController.dart';

class ChatScreenController extends GetxController {
  late final UserRepository _userRepo;
  late final UserController _userController;

  @override
  void onInit() {
    super.onInit();
    _userRepo = Get.put(UserRepository(), permanent: true);
    _userController = Get.put(UserController(), permanent: true);

    _userRepo.getSelfInfo();
    _userController.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) async {
      final user = AuthenticationRepository.instance.currentUser;

      if (user != null && message != null) {
        if (message.contains('resume')) {
          await _userController.updateActiveStatus(true);
        } else if (message.contains('pause')) {
          await _userController.updateActiveStatus(false);
        }
      }

      return message;
    });
  }
}
