import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'helper.dart';

abstract class Constant {
  static const String initialURL =
      "https://images.unsplash.com/photo-1516641396056-0ce60a85d49f?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
}

class GoogleFontStyle {
  final double? fontSize;
  final double? height;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;

  GoogleFontStyle({
    this.fontSize,
    this.height,
    this.color,
    this.fontWeight,
    this.fontStyle,
  });

  TextStyle get asTextStyle {
    return GoogleFonts.oxygen(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: height,
    );
  }
}

class AppTextStyle {
  var textHeading1Style = GoogleFontStyle(
    fontSize: 22,
  ).asTextStyle;

  TextStyle textHeading1BoldStyle(BuildContext context, Color? color) {
    return GoogleFontStyle(
            fontSize: 22, fontWeight: FontWeight.w700, color: color)
        .asTextStyle;
  }

  var textHeading2WhiteStyle = GoogleFontStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  ).asTextStyle;

  TextStyle textHeading2Style(BuildContext context) {
    return GoogleFontStyle(
      fontSize: 20,
      color: isDarkMode(context) ? Colors.white : Colors.black,
      fontWeight: FontWeight.w600,
    ).asTextStyle;
  }

  var textSubHeadingStyle = GoogleFontStyle(
    fontSize: 18,
  ).asTextStyle;

  TextStyle textSubHeadingBoldStyle(BuildContext context) {
    return GoogleFontStyle(
            fontSize: 18,
            color: isDarkMode(context) ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600)
        .asTextStyle;
  }

  var textQuotesStyle = GoogleFontStyle(
          fontSize: 18,
          color: Colors.black54,
          fontWeight: FontWeight.w100,
          fontStyle: FontStyle.italic)
      .asTextStyle;

  var qutationsStyle = GoogleFontStyle(
          fontSize: 32,
          color: Colors.black54,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic)
      .asTextStyle;

  var textBodyStyle = GoogleFontStyle(
    fontSize: 16,
    height: 1.8,
  ).asTextStyle;

  TextStyle textNotFoundStyle(BuildContext context) {
    return GoogleFontStyle(
      fontSize: 16,
      color:
          isDarkMode(context) ? Colors.white.withOpacity(0.6) : Colors.black45,
      fontWeight: FontWeight.w300,
    ).asTextStyle;
  }

  TextStyle textBodyLightStyle(BuildContext context) {
    return GoogleFontStyle(
      fontSize: 16,
      color:
          isDarkMode(context) ? Colors.white.withOpacity(0.6) : Colors.black54,
    ).asTextStyle;
  }

  TextStyle textButtonWhiteStyle(BuildContext context) {
    return GoogleFontStyle(
      fontSize: 14,
      color: isDarkMode(context) ? Colors.black : Colors.white,
    ).asTextStyle;
  }

  TextStyle? textButtonStyle(Color? color) {
    return GoogleFontStyle(
      fontSize: 14,
      color: color,
    ).asTextStyle;
  }

  TextStyle textLargeButtonWhiteStyle(BuildContext context) {
    return GoogleFontStyle(
      fontSize: 16,
      color: isDarkMode(context) ? Colors.black : Colors.white,
    ).asTextStyle;
  }

  TextStyle textLargeButtonPrimaryStyle(Color? color) {
    return GoogleFontStyle(
      fontSize: 16,
      color:color,
    ).asTextStyle;
  }

  TextStyle textBodyLightBoldStyle(BuildContext context) {
    return GoogleFontStyle(
            fontSize: 16,
            color: isDarkMode(context)
                ? Colors.white.withOpacity(0.6)
                : Colors.black54,
            fontWeight: FontWeight.w700)
        .asTextStyle;
  }

  TextStyle textBodyLightFontStyle(BuildContext context) {
    return GoogleFontStyle(
      fontSize: 16,
      color:
          isDarkMode(context) ? Colors.white.withOpacity(0.6) : Colors.black54,
    ).asTextStyle;
  }

  TextStyle textSmallTextStyle(BuildContext context) {
    return GoogleFontStyle(
      fontSize: 14,
      color: isDarkMode(context) ? Colors.white.withOpacity(0.8) : Colors.black,
    ).asTextStyle;
  }

  var textWarningStyle = GoogleFontStyle(
    fontSize: 14,
    color: Colors.red,
  ).asTextStyle;

  TextStyle textExtraSmallDarkTextStyle(BuildContext context) {
    return GoogleFontStyle(
            fontSize: 13,
            color: isDarkMode(context) ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w700)
        .asTextStyle;
  }

  TextStyle textExtraSmallTextStyle(BuildContext context) {
    return GoogleFontStyle(
            fontSize: 13,
            color: isDarkMode(context)
                ? Colors.white.withOpacity(0.5)
                : Colors.black45)
        .asTextStyle;
  }

  var textExtraSmallWhiteTextStyle =
      GoogleFontStyle(fontSize: 13, color: Colors.white).asTextStyle;

  TextStyle textMiniTextStyle(BuildContext context) {
    return GoogleFontStyle(
            fontSize: 11,
            color: isDarkMode(context)
                ? Colors.white.withOpacity(0.6)
                : Colors.black45)
        .asTextStyle;
  }
}

String getDateFormat(Timestamp? dateTime) {
  return DateFormat('dd-MM-yyyy').format(dateTime!.toDate());
}

class ThemeColor {
  static const Color white = Color(0xffffffff);
  static const Color background = Color(0xfff1f1f1);
  static const Color darkBackground = Color(0xff151515);
  static const Color warning = Color(0xffd70000);
 // static const int _christmasTheme = 0xFFF38039;
  static const int _commonTheme = 0xFFF38039;
  // static MaterialColor themes =
  //     MaterialColor(_christmasTheme, <int, Color>{
  //   50: Color(0xFFc2cbca),
  //   100: Color(0xFFa3b5b2).withOpacity(0.2),
  //   200: Color(0xFF555e59),
  //   300: Color(0xff96c7e1),
  //   400: Color(0xFF171c17),
  //   500: Color(0xFF5098b3),
  //   600: Color(0xff357085),
  // });
  static MaterialColor themes =
      MaterialColor(_commonTheme, <int, Color>{
    50: Color(0xffffdfcd),
    100: Color(0xffff5100).withOpacity(0.2),
    200: Color(0xFF555e59),
    300: Color(0xffe1ad96),
    400: Color(0xFF171c17),
    500: Color(0xfffd924a),
    600: Color(0xffff7d21),
  });
}
