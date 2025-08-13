
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/colors.dart';
import '../theme/dimens.dart';
import '../theme/text.dart';
import 'icon_button.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom(
      {super.key,
      required this.title,
      this.isBackButtonVisible = true,
      this.backgroundColor,
      this.titleColor,
      this.isLineVisible});

  final String title;
  final bool? isBackButtonVisible;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool? isLineVisible;

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + Dimens.defaultPadding);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: backgroundColor ?? AppColors.blue.shade50,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: AppTextStyles.headline5.copyWith(
          fontWeight: FontWeight.w400,
          color: titleColor ?? AppColors.black.shade900,
        ),
      ),
      leading: isBackButtonVisible == true
          ? Padding(
              padding: const EdgeInsets.only(left: Dimens.defaultMarginB),
              child: CustomIconButton(
                icon: Iconsax.arrow_left_2,
                iconColor: AppColors.black,
                backgroundColor: Colors.white,
                borderColor: AppColors.border,
                size: Dimens.iconSizeL,
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(Dimens.defaultMarginB),
        child: Container(
          color: Colors.grey.shade300,
          height: (isLineVisible ?? true) ? 1.0 : 0.0,
        ),
      ),
    );
  }
}
