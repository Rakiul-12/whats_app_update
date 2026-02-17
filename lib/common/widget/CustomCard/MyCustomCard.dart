import 'package:flutter/material.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';

class MyCustomCard extends StatelessWidget {
  const MyCustomCard({
    super.key,
    required this.user,
    this.onTap,
    required this.child,
  });

  final UserModel user;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 75,
        width: 100,
        decoration: BoxDecoration(
          // color: Color.fromARGB(53, 196, 196, 196),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color.fromARGB(200, 98, 109, 119),
            width: 1.5,
          ),
        ),
        child: Padding(padding: EdgeInsets.all(5.0), child: child),
      ),
    );
  }
}
