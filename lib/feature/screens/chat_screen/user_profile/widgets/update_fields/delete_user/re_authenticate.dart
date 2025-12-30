import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:whats_app/common/widget/appbar/MyAppBar.dart';
import 'package:whats_app/common/widget/button/MyElevatedButton.dart';
import 'package:whats_app/common/widget/style/screen_padding.dart';
import 'package:whats_app/feature/personalization/controller/UserController.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';
import 'package:whats_app/utiles/validation/Validations.dart';

class ReAuthenticate extends StatelessWidget {
  const ReAuthenticate({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = MyHelperFunction.isDarkMode(context);
    final controller = UserController.instance;
    return Scaffold(
      appBar: MyAppbar(showBackArrow: true, title: Text("Re-authenticate")),
      floatingActionButton: MyElevatedButton(
        text: "Verify",
        onPressed: () => controller.sendOtpForDelete(),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: MyPadding.screenPadding,
        child: Column(
          children: [
            Text(
              "For your security, please verify your phone number before we permanently delete your account.",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isDark ? Mycolors.light : Mycolors.dark,
              ),
            ),

            SizedBox(height: Mysize.defaultSpace),
            Form(
              key: controller.reAuthenticateKey,
              child: TextFormField(
                controller: controller.reAuthenticate,
                validator: (value) => MyValidator.validatePhoneNumber(value),
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: Icon(Iconsax.call),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
