import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_app/feature/authentication/backend/MessageRepo/MessageRepository.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key, required this.message});

  final Map<String, dynamic> message;

  @override
  Widget build(BuildContext context) {
    final bool isDark = MyHelperFunction.isDarkMode(context);

    final String text = (message['msg'] ?? '').toString();
    final dynamic time = message['sent'];
    final bool isSeen = (message['read'] ?? '').toString().isNotEmpty;

    final String? fromId = message['fromId'] as String?;
    final String myId = FirebaseAuth.instance.currentUser!.uid;
    final bool isSentByMe = fromId == myId;

    final String type = (message['type'] ?? 'text').toString();
    final bool isImage = type == 'image';

    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        padding: EdgeInsets.symmetric(
          vertical: isImage ? 6 : 10,
          horizontal: isImage ? 6 : 14,
        ),
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
            // text OR image
            if (isImage)
              GestureDetector(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    text,
                    width: 280,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingprogress) {
                      if (loadingprogress == null) return child;
                      return Container(
                        width: 220,
                        height: 220,
                        color: Colors.black26,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, color: Colors.white70),
                  ),
                ),
              )
            else
              Text(
                text,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Mycolors.light,
                  fontSize: 15,
                ),
              ),

            const SizedBox(height: 4),

            // TIME + DOUBLE TICK
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
                SizedBox(width: Mysize.sm),
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
