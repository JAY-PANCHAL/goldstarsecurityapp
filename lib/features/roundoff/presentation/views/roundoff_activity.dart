import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';
import 'package:golstarsecurityapplatest/features/roundoff/presentation/controllers/roundoff_activity_controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class RoundoffActivity extends StatelessWidget {
  const RoundoffActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RoundoffActivityController>();
    final code = Get.arguments as String?;
    if (code != null) {
      controller.startRoundoff(code);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Round Off Scan')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Column(
          children: [
            Expanded(
              child: MobileScanner(
                onDetect: (capture) {
                  final barcode = capture.barcodes.first;
                  final value = barcode.rawValue;
                  if (value != null && value.isNotEmpty) {
                    controller.scanCheckpoint(value);
                  }
                },
              ),
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Scanned: ${controller.scannedCount.value}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: controller.completeRoundoff,
                child: const Text('Complete Round Off'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
