import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';
import 'package:golstarsecurityapplatest/core/widgets/glass_card.dart';
import 'package:golstarsecurityapplatest/features/roundoff/data/models/roundoff_schedule_model.dart';
import 'package:golstarsecurityapplatest/features/roundoff/presentation/controllers/roundoff_list_controller.dart';
import 'package:golstarsecurityapplatest/app/routes/app_routes.dart';

class RoundoffLanding extends StatelessWidget {
  const RoundoffLanding({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RoundoffListController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Round Off Activity')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Obx(() {
          final list = controller.schedules;
          if (list.isEmpty) {
            return const Center(
              child: Text(
                'No schedules',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final item = list[index];
              return InkWell(
                onTap: () => _openActions(context, item),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.buildingName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${item.rDate} ${item.rTime}',
                        style: const TextStyle(color: AppColors.accentGold),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _statusChip(item.status),
                          const SizedBox(width: 8),
                          Text(
                            'Checkpoints: ${item.checkPointCount}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: list.length,
          );
        }),
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color;
    if (status == 'Completed') {
      color = AppColors.success;
    } else if (status == 'Overdue') {
      color = AppColors.error;
    } else {
      color = AppColors.warning;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 12)),
    );
  }

  void _openActions(BuildContext context, RoundoffScheduleModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryVariant,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              item.buildingName,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.toNamed(AppRoutes.roundoffActivity, arguments: item.code);
              },
              child: const Text('Start Round Off'),
            ),
            TextButton(onPressed: () => Get.back(), child: const Text('Close')),
          ],
        ),
      ),
    );
  }
}
