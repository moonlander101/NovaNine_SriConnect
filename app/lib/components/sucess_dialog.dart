import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/text.dart';
import 'icon_button.dart';
import 'primary_button.dart';
import 'secondary_button.dart';

class SucessDialog extends StatelessWidget {
  final String text;
  final String? subText;
  final String buttonText;
  final Color backgroundColor;
  final String? imagePath;
  final void Function() onPressed;
  final bool hasCancelButton;

  const SucessDialog({
    super.key,
    required this.text,
    required this.buttonText,
    this.subText,
    this.imagePath,
    this.backgroundColor = Colors.white,
    required this.onPressed,
    this.hasCancelButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: backgroundColor,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                height: 100.0,
                width: 70.0,
              ),
            // SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(text, style: AppTextStyles.headline5),
                const Spacer(),
                CustomIconButton(
                  height: 36,
                  icon: Icons.close,
                  iconColor: AppColors.black,
                  backgroundColor: Colors.transparent,
                  borderColor: AppColors.border,
                  size: 18,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            if (subText != null)
              Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                subText!,
                style: AppTextStyles.body2,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                ),
              ),
              ),
            SizedBox(height: 20.0),
            !hasCancelButton
                ? SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      onPressed: onPressed,
                      label: buttonText,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            onPressed: () => Navigator.of(context).pop(),
                            label: 'Cancel',
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: PrimaryButton(
                            onPressed: onPressed,
                            label: buttonText,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
