import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/text.dart';

Widget billPaymentWidget(
    String svgAsset, String label, VoidCallback onPressed, Color? color) {
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
              color: color,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                svgAsset,
                width: 48,
                height: 48,
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
