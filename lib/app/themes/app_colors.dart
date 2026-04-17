import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0A1931);
  static const Color primaryVariant = Color(0xFF1B3A5C);
  static const Color accentGold = Color(0xFFF0A500);
  static const Color accentLightGold = Color(0xFFFFD166);
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textOnLight = Color(0xFF0A1931);

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A1931), Color(0xFF152642)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
