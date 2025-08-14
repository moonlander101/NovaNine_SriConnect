import 'package:gap/gap.dart';

class Dimens {
  static const double baseSize = 8;

  static const double defaultScreenMargin = 32; // screen
  static const double defaultScreenMarginSM = 24; // appbar

  static const double defaultMargin = 24; // between 2 section
  static const double defaultMarginSM = 16;
  static const double defaultMarginB = 12; // between 2 item

  static const double defaultRadius = 12;
  static const double defaultRadiusM = 16;
  static const double defaultRadiusL = 24;

  static const double defaultPaddingSM = 8;
  static const double defaultPadding = 16;

  static const double iconSize = 16;
  static const double iconSizeL = 20;
  static const double iconSizeXL = 24;

  static Gap space(double multiplier) => Gap(baseSize * multiplier);
}
