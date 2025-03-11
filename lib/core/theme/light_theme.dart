import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';

import '../../utils/dimensions.dart';

ThemeData light = ThemeData(
  useMaterial3: true,
  fontFamily: 'Ubuntu',
  primaryColor: const Color(0xFF23A462),
  // primaryColor: const Color(0xFF003EFF),
  // primaryColorLight: const Color(0xFFF6F6F6),
  // primaryColor: const Color(0xffEEF9FC),
  primaryColorLight: const Color(0xffCEE3E5),

  dividerColor: const Color(0xff666666),
  primaryColorDark: const Color(0xFF10324A),
  secondaryHeaderColor: const Color(0xFF9BB8DA),
  disabledColor: const Color(0xFF8797AB),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  brightness: Brightness.light,
  hintColor: const Color(0xFFC0BFBF),
  focusColor: const Color(0xFFFFF9E5),
  hoverColor: const Color(0xFFF1F7FC),
  shadowColor: Colors.grey[300],
  cardColor: Colors.white,
  appBarTheme: const AppBarTheme(color: Color(0xFF23A462)),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(),
  sliderTheme: const SliderThemeData(
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10)),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          // foregroundColor: const Color(0xFF0461A5),
        foregroundColor: Colors.black,
          padding: EdgeInsets.zero,
          iconColor: Colors.black,
          textStyle: const TextStyle(color: Colors.black))),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
    titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
  ),

  colorScheme: const ColorScheme.light(
          primary: Color(0xFF23A462),
          secondary: Color(0xFFFF9900),
          outline: Color(0xFFFDCC0D),
          error: Color(0xFFFF6767),
          surface: Color(0xffFCFCFC),
          tertiary: Color(0xFFd35221))
      .copyWith(surface: const Color(0xffFCFCFC))
      .copyWith(error: const Color(0xFFFF6767)),
  iconTheme: const IconThemeData(size: 16, color: Colors.black),
  expansionTileTheme: ExpansionTileThemeData(
    backgroundColor: Colors.transparent,
    collapsedBackgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(side: BorderSide.none),
    childrenPadding: const EdgeInsets.only(top: 40),
    expansionAnimationStyle: AnimationStyle(
        curve: Curves.linear, duration: const Duration(milliseconds: 400)),
  ),

  // iconButtonTheme: IconButtonThemeData(
  //     style: ButtonStyle(
  //   backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFFCEE3E5)),
  //   iconSize: WidgetStateProperty.all(16),
  //   iconColor: WidgetStateProperty.all<Color>(Colors.black),
  //   overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
  // )),
  switchTheme: SwitchThemeData(
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      thumbColor: WidgetStateProperty.all(Colors.black),
      trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> state) {
        if (state.contains(WidgetState.selected)) {
          return Colors.greenAccent[100];
        } else {
          return const Color(0xffCEE3E5);
        }
      })),
);
