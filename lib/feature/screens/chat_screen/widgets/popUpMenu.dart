import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class popUpMenu extends StatelessWidget {
  const popUpMenu({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = MyHelperFunction.isDarkMode(context);
    return PopupMenuButton<int>(
      color: isDark ? Color(0xFF2A2A2A) : Colors.white,
      elevation: 3,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      icon: Icon(
        Icons.more_vert,
        color: isDark ? Mycolors.light : Mycolors.dark,
        size: 28,
      ),

      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {},
          value: 1,
          child: Text(
            "New group",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            "New broadcast",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            "Linked devices",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            "Starred",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            "Read All",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        PopupMenuItem(
          value: 3,
          onTap: () {},
          child: Text(
            "Setting",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
