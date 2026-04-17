import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';

class SwipeButton extends StatelessWidget {
  final String label;
  final Future<void> Function(ActionSliderController controller) onSlide;

  const SwipeButton({super.key, required this.label, required this.onSlide});

  @override
  Widget build(BuildContext context) {
    return ActionSlider.standard(
      action: onSlide,
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textOnLight,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.white.withOpacity(0.12),
      toggleColor: AppColors.accentGold,
      icon: const Icon(Icons.arrow_forward, color: AppColors.textOnLight),
    );
  }
}
