import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../theme/colors.dart';
import '../theme/text.dart';

class ColorContainer extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double height;
  final double iconSize;
  final IconData? icon;

  const ColorContainer(
    this.text, {
    super.key,
    this.onTap,
    this.height = 30,
    this.iconSize = 18,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 16),
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: height,
                height: height,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Iconsax.receipt,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
