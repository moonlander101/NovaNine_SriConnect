import 'package:lanka_connect/theme/colors.dart';
import 'package:flutter/material.dart';
import '../../../theme/dimens.dart';
import '../../../theme/text.dart';

Widget serviceCard(String imagePath, String title,
    VoidCallback onPressed) {
  return SizedBox(
    width: 300,
    height: 180,
    child: GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.defaultRadiusL),
            child: Image.asset(
              imagePath,
              width: 300,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.defaultRadiusL),
              // gradient: LinearGradient(
              //   begin: Alignment.centerLeft,
              //   end: Alignment.centerRight,
              //   colors: [
              //     AppColors.black.shade800,
              //     Colors.transparent,
              //   ],
              // ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.title2.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   left: 16,
          //   bottom: 16,
          //   child: GlossyContainer("View"),
          // ),
        ],
      ),
    ),
  );
}
