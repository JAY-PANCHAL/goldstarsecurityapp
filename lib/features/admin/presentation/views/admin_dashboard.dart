import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';
import 'package:golstarsecurityapplatest/app/routes/app_routes.dart';
import 'package:golstarsecurityapplatest/core/widgets/glass_card.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Control Center')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _navCard(
              'Manage Security Team',
              () => Get.toNamed(AppRoutes.adminSecurityTeam),
            ),
            _navCard(
              'Manage Buildings',
              () => Get.toNamed(AppRoutes.adminBuildings),
            ),
            _navCard('Manage Floors', () => Get.toNamed(AppRoutes.adminFloors)),
            _navCard(
              'Manage Checkpoints',
              () => Get.toNamed(AppRoutes.adminCheckpoints),
            ),
            _navCard(
              'Manage Schedules',
              () => Get.toNamed(AppRoutes.adminSchedules),
            ),
            _navCard(
              'Assign Schedule',
              () => Get.toNamed(AppRoutes.adminAssignSchedule),
            ),
            _navCard(
              'Roundoff Report',
              () => Get.toNamed(AppRoutes.adminReport),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navCard(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: GlassCard(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
