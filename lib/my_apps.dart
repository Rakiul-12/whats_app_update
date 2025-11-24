import 'package:flutter/material.dart';
import 'package:whats_app/feature/authentication/screens/welcome_screen.dart';
import 'package:whats_app/utiles/theme/themes.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: Mytheme.lightTheme,
      darkTheme: Mytheme.darkTheme,
      // initialBinding: MyBindings(),
      home: welcome_screen(),
    );
  }
}
