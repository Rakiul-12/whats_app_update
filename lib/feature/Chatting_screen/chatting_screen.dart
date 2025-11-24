import 'package:flutter/material.dart';
import 'package:whats_app/common/widget/chatting_app_bar/chatting_app_bar.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class ChattingScreen extends StatelessWidget {
  const ChattingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = MyHelperFunction.isDarkMode(context);
    return Scaffold(
      // AppBar
      appBar: ChatAppBar(name: "Rakibul islam", subtitle: "Online"),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                // TEXT FIELD
                Expanded(
                  child: TextFormField(
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.emoji_emotions,
                          color: isDark ? Mycolors.dark : Mycolors.light,
                        ),
                      ),

                      suffixIcon: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () {},
                              icon: Icon(
                                Icons.camera_alt,
                                color: isDark ? Mycolors.dark : Mycolors.light,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () {},
                              icon: Icon(
                                Icons.image_rounded,
                                color: isDark ? Mycolors.dark : Mycolors.light,
                              ),
                            ),
                          ],
                        ),
                      ),

                      hintText: "Message...",

                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(
                        207,
                        209,
                        200,
                        200,
                      ), // optional background color
                    ),
                  ),
                ),

                SizedBox(width: 10),

                // SEND BUTTON
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
