import 'package:flutter/material.dart';

class AppColors {
  // Design system colors
  static const Color black50 = Color(0xFFFFFFFF);
  static const Color black800 = Color(0xFF000000);
  static const Color black400 = Color(0xFF838383);
  static const Color blue800 = Color(0xFF021627);
  static const Color blue400 = Color(0xFF2BA1F3);
  static const Color black300 = Color(0xFFCACACA);
  static const Color black700 = Color(0xFF1C1D21);
  static const Color blue200 = Color(0xFFDDEAFE);
  static const Color blue50 = Color(0xFFFAFDFF);
  static const Color blue500 = Color(0xFF1F7BBB);
  static const Color black500 = Color(0xFF515356);
  static const Color black200 = Color(0xFFE1E1E2);
  static const Color extraRed = Color(0xFFEA493C);
  static const Color extraRed50 = Color(0xFFFFF5F4);
  static const Color success50 = Color(0xFFECFDF3);
  static const Color success100 = Color(0xFFD1FADF);
  static const Color success600 = Color(0xFF039855);
  
  // Background colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  
  // Primary colors from design
  static const Color primaryBlue = blue400;
  static const Color primaryText = black700;
  static const Color secondaryText = black400;
  static const Color borderColor = black300;
  static const Color inputBorder = blue200;
  static const Color errorColor = extraRed;
  static const Color disabledColor = black400;
  static const Color disabledTextColor = black200;
}

class AppSizes {
  static const double screenMargin = 24.0;
  static const double screenPadding = 32.0;
  static const double spacingSm = 8.0;
  static const double spacingSmd = 12.0;
  static const double spacingXxxl = 40.0;
  static const double borderRadiusS = 13.0;
  static const double borderRadiusM = 16.0;
  static const double borderRadiusL = 32.0;
  static const double borderRadiusXL = 48.0;
  static const double borderRadiusXXL = 64.0;
  
  // Progress indicator sizes
  static const double progressIndicatorSize = 40.0;
  static const double progressLineHeight = 2.0;
}

class AppFonts {
  static const String notoSans = 'Noto Sans';
  static const String dmSans = 'DM Sans';
  static const String inter = 'Inter';
}

class AppTextStyles {
  static const TextStyle heading28 = TextStyle(
    fontFamily: AppFonts.notoSans,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.black800,
    letterSpacing: 0.2,
  );

  static const TextStyle heading24 = TextStyle(
    fontFamily: AppFonts.dmSans,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static const TextStyle heading20 = TextStyle(
    fontFamily: AppFonts.notoSans,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
    letterSpacing: 0.2,
  );

  static const TextStyle body16 = TextStyle(
    fontFamily: AppFonts.notoSans,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
    letterSpacing: 0.2,
  );

  static const TextStyle body16Medium = TextStyle(
    fontFamily: AppFonts.notoSans,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
    letterSpacing: 0.2,
  );

  static const TextStyle body14 = TextStyle(
    fontFamily: AppFonts.dmSans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
    height: 1.29,
  );

  static const TextStyle body12 = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.black500,
    height: 1.33,
  );

  static const TextStyle placeholder = TextStyle(
    fontFamily: AppFonts.notoSans,
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: AppColors.secondaryText,
    letterSpacing: 0.2,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: AppFonts.notoSans,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    letterSpacing: 0.2,
  );

  static const TextStyle linkText = TextStyle(
    fontFamily: AppFonts.notoSans,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryBlue,
    letterSpacing: 0.2,
  );

  static const TextStyle smallText = TextStyle(
    fontFamily: AppFonts.notoSans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black500,
    letterSpacing: 0.2,
  );
}
