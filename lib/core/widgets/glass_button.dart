import 'package:flutter/material.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';

class GlassButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const GlassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [AppColors.accentGold, AppColors.accentLightGold],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          gradient: isPrimary ? gradient : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: isPrimary ? 0 : 1.5,
          ),
          color: isPrimary ? null : Colors.white.withOpacity(0.08),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textOnLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
