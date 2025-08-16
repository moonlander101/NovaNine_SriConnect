import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/dimens.dart';
import '../theme/text.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.onTap,
    this.selectedIndex,
  }) : super();

  final List<String> tabs;
  final Function(int) onTap;
  final int? selectedIndex;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppColors.white.withOpacity(0.1),
        borderRadius: const BorderRadius.all(
          Radius.circular(3 * Dimens.defaultRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widget.tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                    widget.onTap(index);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: index == _selectedIndex
                        ? AppColors.white
                        : Colors.transparent,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(3 * Dimens.defaultRadius),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Text(
                    tab,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.title3.copyWith(
                      color: index == _selectedIndex
                          ? AppColors.black
                          : AppColors.white,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
