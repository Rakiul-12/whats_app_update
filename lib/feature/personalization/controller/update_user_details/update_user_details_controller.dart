import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/data/repository/user/UserRepository.dart';
import 'package:whats_app/feature/personalization/controller/UserController.dart';
import 'package:whats_app/utiles/popup/MyFullScreenLoader.dart';
import 'package:whats_app/utiles/popup/SnackbarHepler.dart';

class updateUserDetailsController extends GetxController {
  static updateUserDetailsController get instance => Get.find();

  final updateUserNameFormKey = GlobalKey<FormState>();
  final userController = UserController.instance;
  final userRepo = Get.put(UserRepository());

  final userNameController = TextEditingController();

  void initializeNames() {
    userNameController.text = userController.user.value.username;
  }

  @override
  void onInit() {
    super.onInit();
    userNameController.text = userController.user.value.username;
  }

  Future<void> updateUserName() async {
    try {
      if (!updateUserNameFormKey.currentState!.validate()) {
        return;
      }

      final newName = userNameController.text.trim();
      if (newName.isEmpty) {
        MyFullScreenLoader.stopLoading();
        MySnackBarHelpers.errorSnackBar(title: "Name can't be empty");
        return;
      }

      await userRepo.updateSingleField({"username": newName});

      userController.user.update((val) {
        if (val == null) return;
        val.username = newName;
      });
      userController.user.refresh();

      Get.back();

      MySnackBarHelpers.successSnackBar(
        title: "Success",
        message: "Your name has been updated",
      );
    } catch (e) {
      MyFullScreenLoader.stopLoading();
      MySnackBarHelpers.errorSnackBar(
        title: "Update Failed!",
        message: e.toString(),
      );
    }
  }

  @override
  void onClose() {
    userController.dispose();
    super.onClose();
  }
}
