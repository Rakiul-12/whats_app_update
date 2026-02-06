import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:whats_app/data/service/App_Lifecycle_Service/app_lifecycle_service.dart';
import 'package:whats_app/data/service/notification_service/NotificationService.dart';
import 'package:whats_app/data/service/zego_service.dart';
import 'package:whats_app/feature/authentication/backend/MessageRepo/MessageRepository.dart';
import 'package:whats_app/feature/authentication/backend/call_repo/call_repo.dart';
import 'package:whats_app/feature/personalization/controller/UserController.dart';
import 'package:whats_app/firebase_options.dart';
import 'package:whats_app/my_apps.dart';
import 'data/repository/authentication_repo/AuthenticationRepo.dart';

@pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   debugPrint('FCM background: ${message.data}');
// }
final navigatorKey = GlobalKey<NavigatorState>();
StreamSubscription<User?>? _authSub;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // controller/repo
  Get.put(AuthenticationRepository(), permanent: true);
  Get.put(UserController(), permanent: true);
  Get.put(AppLifecycleService(), permanent: true);
  Get.put(CallRepo(), permanent: true);
  await Messagerepository.initMe();

  // background handler
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // notification service
  await NotificationService.instance.initLocalNotifications();
  NotificationService.instance.initFcmListeners();
  await NotificationService.instance.requestAndroidPermissionIfNeeded();
  _authSub = FirebaseAuth.instance.authStateChanges().listen((
    User? user,
  ) async {
    if (user == null) {
      ZegoService.instance.uninit();
      return;
    }

    final String userId = user.uid;

    final String safeName =
        (user.displayName ?? user.phoneNumber ?? "Guest").trim().isEmpty
        ? "Guest"
        : (user.displayName ?? user.phoneNumber ?? "Guest").trim();

    final String userPhone = (user.phoneNumber ?? "").trim();

    await ZegoService.instance.initIfNeeded(
      navigatorKey: navigatorKey,
      userId: userId,
      userName: safeName,
      userPhone: userPhone,
    );
  });

  runApp(MyApp(navigatorKey: navigatorKey));
}
