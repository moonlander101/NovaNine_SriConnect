import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/colors.dart';

IconButton notificationButton() {
  return IconButton(
    icon: Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          children: [
            const SizedBox(width: 8),
            Center(
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.notification,
                  color: AppColors.darkGreen,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    ),
    onPressed: () {},
  );
}
