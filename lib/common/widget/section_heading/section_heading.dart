import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';

class MySectionHeading extends StatelessWidget {
  const MySectionHeading({
    super.key,
    required this.title,
    this.buttontitle = "View all",
    this.onPressed,
    this.showActionBtn = true,
  });

  final String title, buttontitle;
  final void Function()? onPressed;
  final bool showActionBtn;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        if (showActionBtn)
          Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 66, 63, 63),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 18, // optional: control size
              onPressed: onPressed,
              icon: const Icon(
                Icons.keyboard_arrow_up_outlined,
                color: Mycolors.borderPrimary,
              ),
            ),
          ),
      ],
    );
  }
}
