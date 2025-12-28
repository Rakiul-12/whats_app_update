import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/data/repository/user/UserRepository.dart';
import 'package:whats_app/feature/personalization/controller/UserController.dart';
import 'package:whats_app/feature/screens/chat_screen/user_profile/widgets/update_fields/phone_number_change/otp_screen.dart';
import 'package:whats_app/utiles/const/keys.dart';
import 'package:whats_app/utiles/popup/MyFullScreenLoader.dart';
import 'package:whats_app/utiles/popup/SnackbarHepler.dart';

class UpdateUserDetailsController extends GetxController {
  static UpdateUserDetailsController get instance => Get.find();

  // form key
  final upDateUserNameFormKey = GlobalKey<FormState>();
  final upDateUserAboutFormKey = GlobalKey<FormState>();
  final upDateUserNumberFormKey = GlobalKey<FormState>();

  // controller
  final userController = UserController.instance;
  final UserRepository userRepo = Get.put(UserRepository());

  // textFiled
  final username = TextEditingController();
  final about = TextEditingController();
  final phoneNumberFirst = TextEditingController();
  final phoneNumberSecond = TextEditingController();
  final otpController = TextEditingController();

  String newNumberE164 = '';
  String? _verificationId;

  @override
  void onInit() {
    super.onInit();
    initializeNames();
  }

  void initializeNames() {
    username.text = userController.user.value.username;
    about.text = userController.user.value.about;
    phoneNumberFirst.text = userController.user.value.phoneNumber;
  }

  // for update user Name
  Future<void> updateUserName() async {
    try {
      MyFullScreenLoader.openLoadingDialog(
        'We are updating your information...',
      );

      if (!upDateUserNameFormKey.currentState!.validate()) {
        MyFullScreenLoader.stopLoading();
        return;
      }

      Map<String, dynamic> map = {"username": username.text};

      userController.user.value.username = username.text;

      await userRepo.updateSingleField(map);

      userController.user.refresh();
      MyFullScreenLoader.stopLoading();
      Get.back();
      MySnackBarHelpers.successSnackBar(
        title: "Congratulations",
        message: "Your name has been updated",
      );
    } catch (e) {
      MyFullScreenLoader.stopLoading();
      MySnackBarHelpers.errorSnackBar(
        title: "Update named failed!",
        message: e.toString(),
      );
      print("Error $e");
    }
  }

  // for update user About
  Future<void> updateUserAbout() async {
    try {
      MyFullScreenLoader.openLoadingDialog(
        'We are updating your information...',
      );

      if (!upDateUserAboutFormKey.currentState!.validate()) {
        MyFullScreenLoader.stopLoading();
        return;
      }
      Map<String, dynamic> map = {"about": about.text};

      userController.user.value.about = about.text;

      await userRepo.updateSingleField(map);

      userController.user.refresh();
      MyFullScreenLoader.stopLoading();
      Get.back();
      MySnackBarHelpers.successSnackBar(
        title: "Congratulations",
        message: "Your name has been updated",
      );
    } catch (e) {
      MyFullScreenLoader.stopLoading();
      MySnackBarHelpers.errorSnackBar(
        title: "Update named failed!",
        message: e.toString(),
      );
      print("Error $e");
    }
  }

  //--------------- CHANGE NUMBER SECTION--------------

  // Send Otp To New Number
  Future<void> sendOtpToNewNumber() async {
    MyFullScreenLoader.openLoadingDialog(
      'We are updating your phone number...',
    );

    final form = upDateUserNumberFormKey.currentState;
    if (form == null || !form.validate()) {
      MyFullScreenLoader.stopLoading();
      return;
    }
    if (phoneNumberSecond.value.text.isEmpty) {
      MyFullScreenLoader.stopLoading();
      return;
    }

    final newNumber = newNumberE164.replaceAll(' ', '');

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: newNumber,
        verificationCompleted: (_) => MyFullScreenLoader.stopLoading(),
        verificationFailed: (e) {
          MyFullScreenLoader.stopLoading();
          Get.snackbar("Verification failed", e.message ?? e.code);
        },
        codeSent: (verificationId, _) {
          MyFullScreenLoader.stopLoading();
          _verificationId = verificationId;
          Get.to(() => ChangeNumberOtpScreen());
        },
        codeAutoRetrievalTimeout: (verificationId) {
          MyFullScreenLoader.stopLoading();
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      MyFullScreenLoader.stopLoading();
      Get.back();
      MySnackBarHelpers.errorSnackBar(title: "Error", message: e.toString());
    }
  }

  // Confirm New Number Otp
  Future<void> confirmNewNumberOtp(String otp) async {
    try {
      if (otp.length != 6) {
        throw "Enter a valid 6-digit code";
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw "User not logged in";
      if (_verificationId == null) throw "OTP expired. Try again.";

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      try {
        await user.updatePhoneNumber(credential);
      } catch (_) {}

      // 🔥 Update Firestore
      await FirebaseFirestore.instance
          .collection(MyKeys.userCollection)
          .doc(user.uid)
          .set({
            "phoneNumber": phoneNumberSecond.text.trim(),
          }, SetOptions(merge: true));

      // ✅ Update local Rx user (if used)
      // UserController.instance.user.update((u) {
      //   if (u == null) return;
      //   u.phoneNumber = phoneNumberSecond.text.trim();
      // });

      Get.back(); // OTP screen
      Get.back(); // Change number screen
      Get.snackbar("Success", "Your number has been updated");
    } catch (e) {
      Get.snackbar("Verification failed", e.toString());
    }
  }

  @override
  void onClose() {
    phoneNumberSecond.dispose();
    otpController.dispose();
    super.onClose();
  }
}
