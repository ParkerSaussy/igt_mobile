import 'package:flutter/material.dart';

import 'color_extension.dart';

class AppThemes {
  // Description: To apply light theme.
  static final light = ThemeData.light().copyWith(
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: Colors.transparent,
      ),
      disabledColor: const Color(0xFF9095AE),
      scaffoldBackgroundColor: lightColorScheme.background,
      cardColor: lightColorScheme.surface,
      dividerColor: const Color(0xFFEAF2FB),
      colorScheme: lightColorScheme);

  // Description: To apply dark theme.
  static final dark = ThemeData.dark().copyWith(
      disabledColor: const Color(0xFF9095AE),
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: Colors.transparent,
      ),
      dividerColor: const Color(0xFFEAF2FB),
      scaffoldBackgroundColor: darkColorScheme.background,
      cardColor: darkColorScheme.surface,
      colorScheme: darkColorScheme);
}
