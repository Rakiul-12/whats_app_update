import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:whats_app/feature/NavBar/navbar.dart';
import 'package:whats_app/feature/authentication/backend/MessageRepo/MessageRepository.dart';
import 'package:whats_app/feature/authentication/screens/log_in_screen/log_in_screen.dart';
import 'package:whats_app/feature/authentication/screens/verify_screen/verify_screen.dart';
import 'package:whats_app/feature/authentication/screens/welcome_screen.dart';
import 'package:whats_app/feature/personalization/screen/profile/profile.dart';
import 'package:whats_app/utiles/popup/MyFullScreenLoader.dart';
import 'package:whats_app/utiles/popup/SnackbarHepler.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String verifyId = '';
  RxString fullPhone = ''.obs;
  final TextEditingController otpController = TextEditingController();

  User? get currentUser => _auth.currentUser;

  final GetStorage localStorage = GetStorage();

  final signUpKey = GlobalKey<FormState>();
  final otpKey = GlobalKey<FormState>();

  late final Messagerepository _messageRepo;

  bool _zegoInited = false;

  @override
  void onInit() {
    super.onInit();
    _messageRepo = Get.put(Messagerepository());
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    // If already logged in
    if (_auth.currentUser != null) {
      await _safeAfterLoginInit();
    }

    FlutterNativeSplash.remove();
    await screenRedirect();
  }

  // Runs ONLY when user is authenticated
  Future<void> _safeAfterLoginInit() async {
    final user = _auth.currentUser;
    if (user == null) return;

    //  Save FCM token for push notifications
    await _messageRepo.saveFcmToken();

    //  Init Zego call invitation service
    _initZegoCallOnce(
      userId: user.uid,
      userName: user.displayName ?? user.phoneNumber ?? 'User',
    );
  }

  void _initZegoCallOnce({required String userId, required String userName}) {
    if (_zegoInited) return;
    _zegoInited = true;

    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 1791254756,
      appSign:
          "6d100a52da23818ae74db2848a4e1dc0d91f09cf1842555b040626051b51ca93",
      userID: userId,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  @override
  void onClose() {
    otpController.dispose();

    // Optional but recommended:
    // stop zego service when app/controller is destroyed
    try {
      ZegoUIKitPrebuiltCallInvitationService().uninit();
    } catch (_) {}

    super.onClose();
  }

  // Redirect to correct screen
  Future<void> screenRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {
      if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) {
        await GetStorage.init(user.uid);
        Get.offAll(() => navigationMenuScreen());
      } else {
        Get.offAll(() => profile_screen());
      }
      return;
    }

    localStorage.writeIfNull("isFirstTime", true);
    final isFirst = localStorage.read("isFirstTime") as bool?;

    if (isFirst == true) {
      Get.offAll(() => welcome_screen());
    } else {
      Get.offAll(() => Log_in_screen());
    }
  }

  // Sign in with phone number
  Future<void> signInWithPhoneNumber() async {
    try {
      MyFullScreenLoader.openLoadingDialog(
        "We are processing your information...",
      );

      if (!signUpKey.currentState!.validate()) {
        MyFullScreenLoader.stopLoading();
        return;
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhone.value,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseException e) {
          MyFullScreenLoader.stopLoading();
          MySnackBarHelpers.errorSnackBar(
            title: "Verification Failed",
            message: e.message ?? "Unknown error",
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          verifyId = verificationId;

          MyFullScreenLoader.stopLoading();
          MySnackBarHelpers.successSnackBar(
            title: "OTP Sent",
            message: "OTP sent on your number",
          );
          Get.to(() => verify_screen());
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verifyId = verificationId;
        },
      );
    } catch (e) {
      MyFullScreenLoader.stopLoading();
      MySnackBarHelpers.errorSnackBar(title: "Failed", message: e.toString());
    }
  }

  // Verify OTP
  Future<void> verifyWithOtp() async {
    try {
      MyFullScreenLoader.openLoadingDialog(
        "We are processing your information...",
      );

      final credential = PhoneAuthProvider.credential(
        verificationId: verifyId,
        smsCode: otpController.text.trim(),
      );

      await _auth.signInWithCredential(credential);

      // After login: save fcm + init zego
      await _safeAfterLoginInit();

      MyFullScreenLoader.stopLoading();
      MySnackBarHelpers.successSnackBar(
        title: "Verified",
        message: "Your number was verified successfully",
      );

      Get.offAll(() => profile_screen());
    } catch (e) {
      MyFullScreenLoader.stopLoading();
      MySnackBarHelpers.errorSnackBar(
        title: "OTP Failed",
        message: e.toString(),
      );
    }
  }
}
