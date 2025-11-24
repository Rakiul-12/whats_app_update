import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/image.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    super.key,
    required this.name,
    this.subtitle,
    this.avatarImage,
    this.onBack,
    this.onProfileTap,
    this.onVideoCall,
    this.onVoiceCall,
    this.onMore,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 70,
  });

  final String name;
  final String? subtitle;
  final ImageProvider? avatarImage;

  final VoidCallback? onBack;
  final VoidCallback? onProfileTap;
  final VoidCallback? onVideoCall;
  final VoidCallback? onVoiceCall;
  final VoidCallback? onMore;

  final Color? backgroundColor;
  final Color? foregroundColor;

  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    bool isDark = MyHelperFunction.isDarkMode(context);
    final bg = backgroundColor ?? Mycolors.dark;
    final fg = foregroundColor ?? Colors.white;

    return AppBar(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leadingWidth: 50,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack ?? () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(MyImage.onProfileScreen),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(color: fg, fontWeight: FontWeight.w600),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(color: fg.withOpacity(0.7), fontSize: 12),
                ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: onVideoCall,
          icon: Icon(
            Icons.videocam_outlined,
            color: isDark ? Mycolors.light : Mycolors.textPrimary,
          ),
        ),
        IconButton(
          onPressed: onVoiceCall,
          icon: Icon(
            Icons.call_outlined,
            color: isDark ? Mycolors.light : Mycolors.textPrimary,
          ),
        ),
        IconButton(
          onPressed: onMore,
          icon: Icon(
            Icons.more_vert,
            color: isDark ? Mycolors.light : Mycolors.textPrimary,
          ),
        ),
      ],
    );
  }
}
