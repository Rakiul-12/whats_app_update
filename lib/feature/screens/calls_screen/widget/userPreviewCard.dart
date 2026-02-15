import 'package:flutter/material.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class UserPreviewCard extends StatelessWidget {
  const UserPreviewCard({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final isDark = MyHelperFunction.isDarkMode(context);

    final bg = isDark ? const Color(0xFF171A1D) : const Color(0xFFF6F7F9);
    final textPrimary = isDark ? Colors.white : const Color(0xFF101418);
    final textSecondary = isDark ? Colors.white70 : Colors.black54;

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: isDark ? Colors.white10 : Colors.black12,
            backgroundImage: (user.profilePicture.toString().isNotEmpty)
                ? NetworkImage(user.profilePicture)
                : null,
            child: (user.profilePicture.toString().isEmpty)
                ? Icon(
                    Icons.person_rounded,
                    color: isDark ? Colors.white70 : Colors.black54,
                  )
                : null,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  user.phoneNumber,
                  style: TextStyle(
                    color: textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 2, 173, 65).withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              "Found",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 2, 173, 65),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
