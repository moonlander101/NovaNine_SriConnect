import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final double size;
  final double? height;
  final double? thickness;

  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.size,
    required this.onPressed,
    this.height,
    this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 48,
      width: height ?? 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: thickness ?? 1),
        color: backgroundColor,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: iconColor,
          size: size,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
