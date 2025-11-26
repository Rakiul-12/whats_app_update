import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class MessageCard extends StatelessWidget {
  MessageCard({super.key});

  final List<Message> messages = [
    Message("Hi, how are you?", false, "10:30 PM"),
    Message("I'm good, bro!", true, "10:31 PM", isSeen: true),
    Message("What's up?", false, "10:32 PM"),
    Message("All good. Working on Flutter UI.", true, "10:33 PM"),
    Message("Another sent message.", true, "10:34 PM", isSeen: true),
    Message("Cool!", false, "10:35 PM"),
    Message("Cool!", false, "10:35 PM"),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = MyHelperFunction.isDarkMode(context);
    return Expanded(
      child: ListView.separated(
        reverse: true,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        separatorBuilder: (context, index) => SizedBox(height: Mysize.sm),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];

          return Align(
            alignment: msg.isSent
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: msg.isSent
                    ? const Color.fromARGB(255, 119, 170, 122)
                    : Color.fromARGB(255, 79, 76, 76),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: msg.isSent
                      ? Radius.circular(12)
                      : Radius.circular(0),
                  bottomRight: msg.isSent
                      ? Radius.circular(0)
                      : Radius.circular(12),
                ),
              ),

              // Message + Time + Tick
              child: Column(
                crossAxisAlignment: msg.isSent
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // MAIN MESSAGE TEXT
                  Text(
                    msg.text,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: isDark ? Mycolors.light : Mycolors.dark,
                      fontSize: 15,
                    ),
                  ),

                  SizedBox(height: 4),

                  // TIME + DOUBLE TICK FOR SENT MSG
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        msg.time,
                        style: TextStyle(fontSize: 11, color: Colors.white70),
                      ),

                      if (msg.isSent) ...[
                        SizedBox(width: 5),
                        Icon(
                          Icons.done_all,
                          size: 16,
                          color: msg.isSeen ? Colors.blue : Colors.white70,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Message {
  final String text;
  final bool isSent;
  final String time;
  final bool isSeen;

  Message(this.text, this.isSent, this.time, {this.isSeen = false});
}
