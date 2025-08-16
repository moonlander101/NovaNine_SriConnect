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
      this.isActionIconVisible,
      this.backgroundColor,
      this.titleColor,
      this.isLineVisible,
      this.actionIcon,
      this.onActionPressed});

  final String title;
  final bool? isBackButtonVisible;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool? isLineVisible;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;
  final bool? isActionIconVisible;

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
            color: titleColor ?? AppColors.black.shade900,
            fontWeight: FontWeight.w500),
      ),
      leading: isBackButtonVisible == true
          ? Padding(
              padding: const EdgeInsets.only(left: Dimens.defaultMarginB),
              child: CustomIconButton(
                icon: Iconsax.arrow_left_2,
                iconColor: AppColors.black,
                backgroundColor: Colors.white,
                borderColor: AppColors.blue.shade200,
                size: Dimens.iconSizeL,
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      actions: [
        if (isActionIconVisible == true)
          Padding(
            padding: const EdgeInsets.only(right: Dimens.defaultMarginB),
            child: CustomIconButton(
              icon: actionIcon ?? Iconsax.more,
              iconColor: AppColors.blue,
              backgroundColor: AppColors.white,
              borderColor: AppColors.blue.shade200,
              size: Dimens.iconSizeL,
              onPressed: onActionPressed ?? () {},
            ),
          ),
        const SizedBox(width: Dimens.defaultMarginB),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(Dimens.defaultMarginB),
        child: Container(
          color: AppColors.blue.shade200,
          height: (isLineVisible ?? true) ? .75 : 0.0,
        ),
      ),
    );
  }
}
