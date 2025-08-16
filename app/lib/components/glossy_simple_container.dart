import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../theme/colors.dart';
import '../theme/text.dart';

class GlossyContainer extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const GlossyContainer(this.text, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.glossy,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: AppColors.borderLight,
            width: 0.7,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Transform.rotate(
                    angle: -0.785398, // 45 degrees in radians
                    child: const Icon(
                      Iconsax.arrow_right_1,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
