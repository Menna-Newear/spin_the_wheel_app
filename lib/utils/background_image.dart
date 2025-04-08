import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final Widget child;

  const BackgroundImage({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Artboard 3.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}