import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_app/feature/authentication/backend/MessageRepo/MessageRepository.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key, required this.message});

  final Map<String, dynamic> message;

  @override
  Widget build(BuildContext context) {
    final bool isDark = MyHelperFunction.isDarkMode(context);

    final String text = (message['msg'] ?? '').toString();
    final dynamic time =
        message['sent']; // ❗ no `?? ''`, let helper handle null
    final bool isSeen = (message['isSeen'] ?? false) == true;

    final String? fromId = message['fromId'] as String?;
    final String myId = FirebaseAuth.instance.currentUser!.uid;
    final bool isSentByMe = fromId == myId;

    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isSentByMe
              ? const Color.fromARGB(255, 119, 170, 122)
              : const Color.fromARGB(255, 79, 76, 76),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isSentByMe ? const Radius.circular(12) : Radius.zero,
            bottomRight: isSentByMe ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: isSentByMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // MAIN MESSAGE TEXT
            Text(
              text,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Mycolors.light,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 4),

            // TIME + DAY + DOUBLE TICK
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Messagerepository.getFormattedTime(
                    context: context,
                    time: time,
                  ),
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
                const Text(", "),
                Text(
                  Messagerepository.getLastMessageday(
                    context: context,
                    time: time,
                  ),
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
                if (isSentByMe) ...[
                  const SizedBox(width: 5),
                  Icon(
                    Icons.done_all,
                    size: 16,
                    color: isSeen ? Colors.blue : Colors.white70,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
