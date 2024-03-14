import 'package:daprot_seller/config/theme/fonts_manager.dart';
import 'package:flutter/material.dart';

TextStyle _getTextStyle(
  double fontSize,
  String fontFamily,
  Color color,
  FontWeight fontWeight,
) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
    color: color,
    fontWeight: fontWeight,
  );
}

// regular style

TextStyle getExtraBold({double fontSize = FontSize.s20, required Color color}) {
  return _getTextStyle(
    fontSize,
    FontConstant.fontFamily,
    color,
    FontWeightManager.extraBold,
  );
}

// light text style
TextStyle getLightStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
    fontSize,
    FontConstant.fontFamily,
    color,
    FontWeightManager.light,
  );
}

// semi bold text style
TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s14, required Color color}) {
  return _getTextStyle(
    fontSize,
    FontConstant.fontFamily,
    color,
    FontWeightManager.semiBold,
  );
}
