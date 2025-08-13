import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/colors.dart';
import '../theme/dimens.dart';
import '../theme/text.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading,
    this.isActive = true,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool? isLoading;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (isActive ?? true) && !(isLoading ?? false) ? onPressed : null,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2 * Dimens.defaultRadiusL),
        ),
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: 16,
          right: 8,
        ),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(Dimens.defaultRadiusL),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                (isLoading ?? false) ? 'Loading...' : label,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.blue,
                shape: BoxShape.circle,
              ),
              child: (isLoading ?? false)
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2.5,
                        ),
                      ),
                    )
                  : Transform.rotate(
                      angle: -0.785398,
                      child: const Icon(
                        Iconsax.arrow_right_1,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
