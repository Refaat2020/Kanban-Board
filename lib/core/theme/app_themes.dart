import 'package:flutter/material.dart';
import 'package:kanban_board/core/constants/app_colors.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: AppColors.white,
    cardColor: AppColors.geryColor2,
    fontFamily: 'IBM',
    textTheme: _textTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: AppColors.black,
    cardColor: AppColors.darkCard,
    fontFamily: 'IBM',
    textTheme: _textTheme,
  );

  static final TextTheme _textTheme = TextTheme(
    titleLarge: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w800,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.w400,
    ),
  );
}
