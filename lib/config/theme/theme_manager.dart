import 'package:gozip_seller/config/theme/text_style_manager.dart';
import 'package:flutter/material.dart';

import 'colors_manager.dart';

ColorScheme kColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: ColorsManager.primaryColor,
  secondary: ColorsManager.secondaryColor,
  surface: ColorsManager.offWhiteColor,
);
ThemeData getApplicationTheme() {
  return ThemeData(
    fontFamily: 'Poppins',
    colorScheme: kColorScheme,
    primaryColor: ColorsManager.primaryColor,
    appBarTheme: const AppBarTheme().copyWith(
      color: kColorScheme.secondary,
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
    timePickerTheme: const TimePickerThemeData(
        backgroundColor: ColorsManager.whiteColor,
        hourMinuteColor: ColorsManager.secondaryColor,
        hourMinuteTextColor: ColorsManager.whiteColor,
        dayPeriodColor: ColorsManager.secondaryColor,
        dayPeriodTextColor: ColorsManager.greyColor,
        dialHandColor: ColorsManager.secondaryColor,
        confirmButtonStyle: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(ColorsManager.secondaryColor),
          foregroundColor: WidgetStatePropertyAll(ColorsManager.whiteColor),
        ),
        timeSelectorSeparatorColor: WidgetStatePropertyAll(
          ColorsManager.offWhiteColor,
        )),
  );
}
