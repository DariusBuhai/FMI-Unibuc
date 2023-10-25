import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

const double HORIZONTAL_PADDING = 15;
const double BORDER_RADIUS = 10;

class Styles {

  static const Color primaryColor = CupertinoColors.systemBlue;
  static const Color primaryColorMaterial = Colors.blue;

  static TextTheme buildTextTheme(TextTheme base, {bool dark = false}) {

    return base.copyWith(
      subtitle1: base.subtitle2.copyWith(
          fontWeight: FontWeight.w700,
          color: dark ? Colors.white70 : Colors.black87,
          fontSize: 16,
          fontFamily: GoogleFonts.poppins().fontFamily),
      subtitle2: base.subtitle2.copyWith(
          fontWeight: FontWeight.w700,
          color: dark ? Colors.white70 : Colors.black87,
          fontSize: 14,
          fontFamily: GoogleFonts.poppins().fontFamily),
      headline1: TextStyle(
          fontSize: 30,
          color: dark ? Colors.white70 : Colors.black87,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w800
      ),
      headline2: TextStyle(
          fontSize: 26,
          color: dark ? Colors.white70 : Colors.black87,
          fontWeight: FontWeight.w800,
          fontFamily: GoogleFonts.poppins().fontFamily),
      headline3: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w800,
          color: dark ? Colors.white70 : Colors.black87,
          fontFamily: GoogleFonts.poppins().fontFamily),
      headline4: TextStyle(
          fontSize: 22,
          color: dark ? Colors.white70 : Colors.black87,
          fontFamily: GoogleFonts.poppins().fontFamily),
      headline5: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: dark ? Colors.white70 : Colors.black87,
          fontFamily: GoogleFonts.poppins().fontFamily),
      headline6: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: dark ? Colors.white70 : Colors.black87,
          fontFamily: GoogleFonts.poppins().fontFamily),
    );
  }

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    ThemeData _themeData = ThemeData(
        textTheme: Styles.buildTextTheme(
            isDarkTheme
                ? ThemeData.dark().textTheme
                : ThemeData.light().textTheme,
            dark: isDarkTheme),
        primarySwatch: Styles.primaryColorMaterial,
        primaryColor: Styles.primaryColor,
        backgroundColor: isDarkTheme ? Colors.grey[200] : const Color(0xffF1F5FB),
        primaryColorDark: isDarkTheme ? Colors.black : Colors.white,
        primaryColorLight: !isDarkTheme ? Colors.black : Colors.white,
        indicatorColor: isDarkTheme ? const Color(0xff0E1D36) : const Color(0xffCBDCF8),
        hintColor: isDarkTheme ? const Color(0xff280C0B) : const Color(0xffEECED3),
        highlightColor: isDarkTheme ? const Color(0xff372901) : const Color(0xffFCE192),
        hoverColor: isDarkTheme ? const Color(0xff3A3A3B) : const Color(0xff4285F4),
        focusColor: isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
        disabledColor: Colors.grey,
        canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDarkTheme
            ? Colors.black
            : CupertinoColors.extraLightBackgroundGray,
        cardColor: isDarkTheme ? Colors.grey[900] : Colors.white,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme:
                isDarkTheme ? const ColorScheme.dark() : const ColorScheme.light()),
        appBarTheme: AppBarTheme(
            elevation: 0.0,
            titleTextStyle:
                TextStyle(color: !isDarkTheme ? Colors.black : Colors.white),
            backgroundColor: isDarkTheme
                ? Colors.black
                : CupertinoColors.extraLightBackgroundGray,
            iconTheme: IconThemeData(
                color: !isDarkTheme ? Colors.black : Colors.white)),
        cupertinoOverrideTheme: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
              primaryColor: Styles.primaryColor,
              dateTimePickerTextStyle: TextStyle(
                  color: isDarkTheme ? Colors.white : Colors.black,
                  fontSize: 21),
              tabLabelTextStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: (isDarkTheme ? Colors.white : Colors.black)
                      .withOpacity(.7),
                  fontFamily: "SF")),
        ),
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Styles.primaryColor
        ));
    return _themeData;
  }
}
