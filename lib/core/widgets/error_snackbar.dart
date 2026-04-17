import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorSnackbar {
  static void show(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
