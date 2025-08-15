import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static lightTheme() => ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.blue,
        colorScheme: const ColorScheme.light(
          primary: AppColors.blue,
        ),
        // scaffoldBackgroundColor: Colors.white,
        fontFamily: "DMSans",
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: "DMSans",
            color: AppColors.darkGreen,
          ),
        ),
      );
}
