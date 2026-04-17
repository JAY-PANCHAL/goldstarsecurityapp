import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';

class SuccessSnackbar {
  static void show(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: AppColors.accentGold,
      colorText: AppColors.primary,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
    );
  }
}
