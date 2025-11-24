import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/image.dart';

class Profile_picture extends StatelessWidget {
  const Profile_picture({super.key, required this.radius, required this.icon});

  final double radius;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: const AssetImage(MyImage.onProfileScreen),
        ),

        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Mycolors.textPrimary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}
