import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/core/services/connectivity_service.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Get.find<ConnectivityService>();
    return Obx(() {
      if (service.isOnline) return const SizedBox.shrink();
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        color: Colors.orange.withOpacity(0.8),
        child: const Text(
          'You are offline. Showing cached data.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      );
    });
  }
}
