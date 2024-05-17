import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_dimens.dart';
import 'constants.dart';

class Font {
  static String? poppins400Regular = /*"MontBook"; */ GoogleFonts.getFont(
    "Poppins",
    fontWeight: FontWeight.w400,
  ).fontFamily;
  static String? poppins500Medium = GoogleFonts.getFont(
    "Poppins",
    fontWeight: FontWeight.w500,
  ).fontFamily;
  static String? poppins600SemiBold = GoogleFonts.getFont(
    "Poppins",
    fontWeight: FontWeight.w600,
  ).fontFamily;
}

// Regular

TextStyle onBackgroundTextStyleRegular(
    {double fontSize = AppDimens.textMedium, int alpha = Constants.darkAlfa}) {
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: fontSize,
      color: Get.theme.colorScheme.onBackground.withAlpha(alpha),
      fontWeight: FontWeight.w400,
    ),
  );
}

TextStyle primaryTextStyleRegular(
    {double fontSize = AppDimens.textMedium, int alpha = Constants.darkAlfa}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    fontSize: fontSize,
    color: Get.theme.colorScheme.primary.withAlpha(alpha),
    fontWeight: FontWeight.w400,
  ));
}

TextStyle primaryTextStyleMedium(
    {double fontSize = AppDimens.textMedium, int alpha = Constants.darkAlfa}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    fontSize: fontSize,
    color: Get.theme.colorScheme.primary.withAlpha(alpha),
    fontWeight: FontWeight.w500,
  ));
}

// Medium

TextStyle onBackGroundTextStyleMedium(
    {double fontSize = AppDimens.textMedium, int alpha = Constants.darkAlfa}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    fontSize: fontSize,
    color: Get.theme.colorScheme.onBackground.withAlpha(alpha),
    fontWeight: FontWeight.w500,
  ));
}

TextStyle onPrimaryTextStyleRegular(
    {double fontSize = AppDimens.textMedium, int alpha = Constants.darkAlfa}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    fontSize: fontSize,
    color: Get.theme.colorScheme.onPrimary.withAlpha(alpha),
    fontWeight: FontWeight.w400,
  ));
}

TextStyle onPrimaryTextStyleMedium(
    {double fontSize = AppDimens.textMedium, int alpha = Constants.darkAlfa}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    fontSize: fontSize,
    color: Get.theme.colorScheme.onPrimary.withAlpha(alpha),
    fontWeight: FontWeight.w500,
  ));
}

//SemiBold
TextStyle onBackgroundTextStyleSemiBold(
    {double fontSize = AppDimens.textMedium, int alpha = Constants.darkAlfa}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
          fontSize: fontSize,
          color: Get.theme.colorScheme.onBackground.withAlpha(alpha),
          fontWeight: FontWeight.w600));
}

TextStyle onSurfaceTextStyleSemiBold(
    {double fontSize = AppDimens.textMedium, int alpha = Constants.darkAlfa}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    fontSize: fontSize,
    color: Get.theme.colorScheme.onBackground.withAlpha(alpha),
    fontWeight: FontWeight.w600,
  ));
}

TextStyle onSurfaceTextStyleRegular(
    {double fontSize = AppDimens.textMedium, int alpha = Constants.darkAlfa}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    fontSize: fontSize,
    color: Get.theme.colorScheme.onBackground.withAlpha(alpha),
    fontWeight: FontWeight.w400,
  ));
}

TextStyle onPrimaryTextStyleSemiBold(
    {double fontSize = AppDimens.textMedium, int alpha = Constants.darkAlfa}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    fontSize: fontSize,
    color: Get.theme.colorScheme.onPrimary.withAlpha(alpha),
    fontWeight: FontWeight.w600,
  ));
}

TextStyle primaryTextStyleSemiBold(
    {double fontSize = AppDimens.textMedium, int alpha = Constants.darkAlfa}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    fontSize: fontSize,
    color: Get.theme.colorScheme.primary.withAlpha(alpha),
    fontWeight: FontWeight.w600,
  ));
}

TextStyle secondaryTextStyleSemiBold(
    {double fontSize = AppDimens.textMedium, int alpha = Constants.darkAlfa}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    fontSize: fontSize,
    color: Get.theme.colorScheme.secondary.withAlpha(alpha),
    fontWeight: FontWeight.w600,
  ));
}

TextStyle secondaryTextStyleRegular(
    {double fontSize = AppDimens.textMedium, int alpha = Constants.darkAlfa}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    fontSize: fontSize,
    color: Get.theme.colorScheme.secondary.withAlpha(alpha),
    fontWeight: FontWeight.w400,
  ));
}

TextStyle secondaryTextStyleMedium(
    {double fontSize = AppDimens.textMedium, int alpha = Constants.darkAlfa}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
    fontSize: fontSize,
    color: Get.theme.colorScheme.secondary.withAlpha(alpha),
    fontWeight: FontWeight.w500,
  ));
}

TextStyle tertiaryTextStyleSemiBold(
    {double fontSize = AppDimens.textMedium, int alpha = Constants.darkAlfa}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
          fontSize: fontSize,
          color: Get.theme.colorScheme.tertiary.withAlpha(alpha),
          fontWeight: FontWeight.w600));
}

TextStyle generalTextStyleMedium(
    {double fontSize = AppDimens.textMedium, Color color = Colors.black}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
          fontSize: fontSize, color: color, fontWeight: FontWeight.w500));
}

TextStyle generalTextStyleRegular(
    {double fontSize = AppDimens.textMedium, Color color = Colors.black}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
          fontSize: fontSize, color: color, fontWeight: FontWeight.w400));
}
