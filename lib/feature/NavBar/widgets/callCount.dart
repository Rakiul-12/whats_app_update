import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';

class NavBadgeIcon extends StatelessWidget {
  const NavBadgeIcon({required this.icon, required this.count});

  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (count > 0)
          Positioned(
            right: 22,
            child: Container(
              height: 18,
              padding: EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 215, 23, 23),
                shape: BoxShape.circle,
              ),
              child: Text(
                count > 99 ? "99+" : count.toString(),
                style: TextStyle(
                  color: Mycolors.light,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
