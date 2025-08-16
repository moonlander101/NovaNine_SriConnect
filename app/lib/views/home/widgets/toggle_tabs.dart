import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

class ToggleTabs extends StatelessWidget {
  final bool isUpcoming;
  final Function(bool) onToggle;

  const ToggleTabs({
    super.key,
    required this.isUpcoming,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      height: 64,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(200),
        border: Border.all(color: AppColors.blue.shade200, width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            offset: Offset(0, 0),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(false),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isUpcoming ? AppColors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Text(
                  'Closed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: !isUpcoming ? Colors.white : AppColors.black.shade500,
                    fontFamily: 'Noto Sans',
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(true),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isUpcoming ? AppColors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Text(
                  'Upcoming',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: isUpcoming ? Colors.white : AppColors.black.shade500,
                    fontFamily: 'Noto Sans',
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
