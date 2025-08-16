import 'package:flutter/material.dart';
import 'package:lanka_connect/theme/text.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/colors.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19.sp, color: AppColors.black.shade600),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$label :",
                  style: AppTextStyles.title3,
                ),
                Text(value, style: AppTextStyles.body2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
