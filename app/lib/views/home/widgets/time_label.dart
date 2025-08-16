import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

class TimeLabel extends StatelessWidget {
  final String time;

  const TimeLabel({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      child: Text(
        time,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.black.shade500,
          fontFamily: 'Inter',
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
