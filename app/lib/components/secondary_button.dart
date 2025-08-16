import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/dimens.dart';
import '../theme/text.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(Dimens.defaultRadiusL),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: Dimens.defaultMarginSM / 1.2,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.title2.copyWith(
          color: AppColors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
