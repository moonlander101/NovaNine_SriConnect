import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/dimens.dart';
import '../../../theme/text.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final IconData icon;
  final VoidCallback onPressed;

  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(Dimens.defaultMarginB),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimens.defaultRadiusL),
          border: Border.all(
            color: AppColors.blue.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.blue,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: Dimens.defaultMargin),
            Text(
              title,
              style:
                  AppTextStyles.title2,
            ),
            const SizedBox(height: Dimens.defaultScreenMarginSM),
            Text(
              description,
              style: AppTextStyles.body2,
            ),
            const SizedBox(height: Dimens.defaultScreenMarginSM),
            GestureDetector(
              onTap: onPressed,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    right: 8, left: 16, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(Dimens.defaultRadiusL),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonText,
                      style: AppTextStyles.body3.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w500),
                    ),
                    // Container(
                    //   width: 30,
                    //   height: 30,
                    //   decoration: BoxDecoration(
                    //     color: AppColors.black,
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: Transform.rotate(
                    //     angle: -0.785398, // 45 degrees in radians
                    //     child: const Icon(
                    //       Iconsax.arrow_right_1,
                    //       color: Colors.white,
                    //       size: 18,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
