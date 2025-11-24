import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';

class Custom_circualar_icon_and_text extends StatelessWidget {
  const Custom_circualar_icon_and_text({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 73, 73, 73),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Mycolors.light, size: 30),
          ),
        ),

        SizedBox(height: Mysize.sm),
        // Text
        Text(text, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
