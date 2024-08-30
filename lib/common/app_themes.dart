import 'package:flutter/material.dart';

import 'app_colors.dart';

// *** light themes ***

ThemeData appThemeLight() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    // themes section
    bottomNavigationBarTheme: _appBottomNavigationBarTheme(base.bottomNavigationBarTheme),
  );
}

BottomNavigationBarThemeData _appBottomNavigationBarTheme(BottomNavigationBarThemeData base) => base.copyWith(
      selectedItemColor: AppColors.blackOlive,
      unselectedItemColor: AppColors.blackOlive20,
    );
