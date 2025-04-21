import 'package:flutter/material.dart';
import 'package:stayzio_app/style/colors/stayzio_palette.dart';
import 'package:stayzio_app/style/typography/stayzio_text_styles.dart';

class StayzioTheme {
  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: StayzioTextStyles.displayLarge,
      displayMedium: StayzioTextStyles.displayMedium,
      displaySmall: StayzioTextStyles.displaySmall,
      headlineLarge: StayzioTextStyles.headlineLarge,
      headlineMedium: StayzioTextStyles.headlineMedium,
      headlineSmall: StayzioTextStyles.headlineSmall,
      titleLarge: StayzioTextStyles.titleLarge,
      titleMedium: StayzioTextStyles.titleMedium,
      titleSmall: StayzioTextStyles.titleSmall,
      bodyLarge: StayzioTextStyles.bodyLargeBold,
      bodyMedium: StayzioTextStyles.bodyLargeMedium,
      bodySmall: StayzioTextStyles.bodyLargeRegular,
      labelLarge: StayzioTextStyles.labelLarge,
      labelMedium: StayzioTextStyles.labelMedium,
      labelSmall: StayzioTextStyles.labelSmall,
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      toolbarTextStyle: _textTheme.titleLarge,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: StayzioPalette.primary800,
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

//  static ThemeData get darkTheme {
//    return ThemeData(
//      colorSchemeSeed: StayzioPalette.primary800,
//      brightness: Brightness.dark,
//      textTheme: _textTheme,
//      useMaterial3: true,
//      appBarTheme: _appBarTheme,
//    );
//  }
}
