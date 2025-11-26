import 'package:flutter/material.dart';
import 'package:whats_app/common/widget/chatting_app_bar/chatting_app_bar.dart';
import 'package:whats_app/feature/Chatting_screen/widget/message_card.dart';
import 'package:whats_app/feature/Chatting_screen/widget/text_field.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class ChattingScreen extends StatelessWidget {
  ChattingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = MyHelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: ChatAppBar(name: "Rakibul islam", subtitle: "Online"),
      body: SafeArea(
        child: Column(
          children: [
            MessageCard(),

            /// Bottom Input Box
            Text_filed(),
          ],
        ),
      ),
    );
  }
}
