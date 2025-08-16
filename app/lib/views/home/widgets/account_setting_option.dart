import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:sizer/sizer.dart';

import '../../../theme/colors.dart';
import '../../../theme/text.dart';

class AccountSettingOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final IconData icon;
  final bool arrow;
  final Color? color;

  const AccountSettingOption({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.color = Colors.black,
    this.arrow = true,
    this.subtitle
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0, 
            horizontal: 0.0,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Icon(
                  icon,
                  size: 20.sp,
                  color: color,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: AppTextStyles.body4.copyWith(
                          color: AppColors.black.shade500,
                        ),
                      ),
                    Text(
                      title,
                      style: AppTextStyles.body2.copyWith(color: color),
                    ),
                  ],
                ),
              ),
              // const Spacer(),
              if (arrow)
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Iconsax.arrow_right_3,
                    size: 18,
                    color: AppColors.black,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
