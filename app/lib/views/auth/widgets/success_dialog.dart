import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'custom_button.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 376,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusM),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: AppColors.success100,
                borderRadius: BorderRadius.circular(58.33),
                border: Border.all(
                  color: AppColors.success50,
                  width: 16.67,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.success600,
                    width: 4.17,
                  ),
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.success600,
                  size: 25,
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Title
            Text(
              title,
              style: AppTextStyles.heading24,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Subtitle
            SizedBox(
              width: 265,
              child: Text(
                subtitle,
                style: AppTextStyles.body14,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            
            // Button
            CustomButton(
              text: buttonText,
              onPressed: onButtonPressed,
              width: 312,
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.24),
      builder: (BuildContext context) {
        return SuccessDialog(
          title: title,
          subtitle: subtitle,
          buttonText: buttonText,
          onButtonPressed: onButtonPressed ?? () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
