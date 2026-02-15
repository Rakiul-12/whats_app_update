import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';

class CallByNumberController extends GetxController {
  static CallByNumberController get instance => Get.find();
  CallByNumberController({
    required this.normalizePhone,
    required this.findUserByPhone,
    required this.phoneController,
  });

  final TextEditingController phoneController;
  final String Function(String) normalizePhone;
  final Future<UserModel?> Function(String) findUserByPhone;

  final isLoading = false.obs;
  final foundUser = Rxn<UserModel>();
  final errorText = RxnString();

  // reset the bottom sheet
  void reset() {
    phoneController.clear();
    isLoading.value = false;
    foundUser.value = null;
    errorText.value = null;
    Get.delete<CallByNumberController>();
  }

  // search user
  Future<void> searchUser() async {
    final raw = phoneController.text.trim();

    if (raw.isEmpty) {
      errorText.value = "Please enter a phone number";
      foundUser.value = null;
      return;
    }

    isLoading.value = true;
    errorText.value = null;
    foundUser.value = null;

    try {
      final normalized = normalizePhone(raw);
      final user = await findUserByPhone(normalized);

      foundUser.value = user;
      if (user == null) {
        errorText.value = "No user found for $normalized";
      }
    } catch (e) {
      errorText.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
