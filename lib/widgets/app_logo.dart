import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 28,
    this.padding = const EdgeInsets.all(0),
  });

  final double size;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Image.asset(
        'assets/images/logo1.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
