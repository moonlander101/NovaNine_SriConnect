import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/colors.dart';
import '../../../theme/text.dart';

Widget categoryIcon(String svgAsset, String label, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.only(right: 16),
    child: Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blue.shade100,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SvgPicture.asset(
                svgAsset,
                width: 36,
                height: 36,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            label,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.black.shade800,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
