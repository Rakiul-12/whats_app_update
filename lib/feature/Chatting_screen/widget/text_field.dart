import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class Text_filed extends StatelessWidget {
  const Text_filed({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = MyHelperFunction.isDarkMode(context);
    return Row(
      children: [
        // TEXT FIELD
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextFormField(
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Mycolors.light : Mycolors.black,
              ),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(1000),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.emoji_emotions,
                    color: isDark ? Mycolors.light : Mycolors.dark,
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
                          color: isDark ? Mycolors.light : Mycolors.dark,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () {},
                        icon: Icon(
                          Icons.image_rounded,
                          color: isDark ? Mycolors.light : Mycolors.dark,
                        ),
                      ),
                    ],
                  ),
                ),

                hintText: "Message...",
                hintMaxLines: 1,

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
        ),

        SizedBox(width: 10),

        // SEND BUTTON
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.send, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
