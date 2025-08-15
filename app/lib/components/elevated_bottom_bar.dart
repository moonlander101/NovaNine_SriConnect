import 'package:flutter/material.dart';
import '../theme/dimens.dart';

class ElevatedBottomBar extends StatelessWidget {
  final Widget child;
  final Color color;

  const ElevatedBottomBar({
    super.key,
    required this.child,
    Color? color, // Default color provided here
  }) : color = color ?? Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.defaultScreenMargin),
      decoration: BoxDecoration(
        color: color, // Use the color property
      ),
      child: SafeArea(
          minimum: EdgeInsets.only(bottom: 2 * Dimens.defaultMargin),
          child: child),
    );
  }
}
