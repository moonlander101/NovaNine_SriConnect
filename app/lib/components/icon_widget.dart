import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/colors.dart';

class IconWidget extends StatelessWidget {
  final String assetName;
  final Color color;

  const IconWidget({super.key, required this.assetName, Color? color})
      : color = color ?? AppColors.black;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
    );
  }
}
