import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';
import 'package:whats_app/feature/screens/calls_screen/controller/CallByNumberController.dart';
import 'package:whats_app/feature/screens/calls_screen/widget/callBottomSheetContent.dart';
import 'package:whats_app/feature/screens/calls_screen/widget/call_list.dart';
import 'package:whats_app/utiles/const/keys.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = MyHelperFunction.isDarkMode(context);

    return Scaffold(
      floatingActionButton: SizedBox(
        height: Mysize.floatingButtonHeight,
        width: Mysize.anotherfloatingButtonWidth,
        child: ElevatedButton(
          onPressed: () => _showPremiumCallSheet(context),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: const Color.fromARGB(255, 2, 173, 65),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 10,
            shadowColor: Colors.black26,
          ),
          child: Icon(
            Icons.add_call,
            size: Mysize.iconMd,
            color: isDark ? Mycolors.black : Mycolors.white,
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("Calls", style: Theme.of(context).textTheme.headlineMedium),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [Expanded(child: Callslist())],
      ),
    );
  }

  //Bottom Sheet for call a random user
  void _showPremiumCallSheet(BuildContext context) {
    final phoneCtrl = TextEditingController();

    final controller = Get.put(
      CallByNumberController(
        normalizePhone: normalizePhone,
        findUserByPhone: _findUserByPhone,
        phoneController: phoneCtrl,
      ),
      tag: "call_by_number",
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      showDragHandle: false,
      builder: (_) {
        final isDark = MyHelperFunction.isDarkMode(context);

        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.40,
          maxChildSize: 0.85,

          builder: (ctx, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF111315) : Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: CallBottomSheetContent(controller: controller),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      // clean controller when sheet closes
      if (Get.isRegistered<CallByNumberController>(tag: "call_by_number")) {
        Get.delete<CallByNumberController>(tag: "call_by_number");
      }
    });
  }

  //normalize phone number
  String normalizePhone(String input) {
    final digits = input.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.startsWith('0')) {
      return '+880${digits.substring(1)}';
    }
    if (digits.startsWith('880')) {
      return '+$digits';
    }
    return '+$digits';
  }

  // get user
  Future<UserModel?> _findUserByPhone(String normalizedPhone) async {
    final snap = await FirebaseFirestore.instance
        .collection(MyKeys.userCollection)
        .where("phoneNumber", isEqualTo: normalizedPhone)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return UserModel.fromSnapshot(snap.docs.first);
  }
}
