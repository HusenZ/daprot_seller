import 'package:daprot_seller/config/theme/text_style_manager.dart';
import 'package:flutter/material.dart';

import 'colors_manager.dart';

ColorScheme kColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: ColorsManager.primaryColor,
  secondary: ColorsManager.secondaryColor,
  background: ColorsManager.offWhiteColor,
);
ThemeData getApplicationTheme() {
  return ThemeData(
    fontFamily: 'Poppins',
    colorScheme: kColorScheme,
    primaryColor: ColorsManager.primaryColor,
    appBarTheme: const AppBarTheme().copyWith(
      color: kColorScheme.onPrimaryContainer,
      foregroundColor: kColorScheme.onSecondary,
    ),
    textTheme: TextTheme(
      bodyLarge: getExtraBold(
        color: ColorsManager.textColor,
      ),
      displayMedium: getSemiBoldStyle(
        color: ColorsManager.textColor,
      ),
      bodySmall: getLightStyle(
        color: ColorsManager.greyColor,
      ),
    ),
  );
}
