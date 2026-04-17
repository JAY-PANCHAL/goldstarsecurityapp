import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/constants/asset_paths.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';
import 'package:golstarsecurityapplatest/core/widgets/glass_card.dart';
import 'package:golstarsecurityapplatest/core/widgets/offline_banner.dart';
import 'package:golstarsecurityapplatest/features/home/presentation/controllers/home_controller.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      drawer: _buildDrawer(controller),
      appBar: AppBar(
        title: const Text('Security Guards'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              const OfflineBanner(),
              const SizedBox(height: 8),
              const Text(
                'Gold Star Security Force',
                style: TextStyle(
                  color: AppColors.accentGold,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ActionCard(
                        title: 'Employee Verification',
                        iconPath: AssetPaths.verificationIcon,
                        onTap: controller.openVerification,
                      ),
                      const SizedBox(height: 18),
                      // TODO: Round-off module is temporarily disabled.
                      // _ActionCard(
                      //   title: 'Round Off Activity',
                      //   iconPath: AssetPaths.roundoffIcon,
                      //   onTap: controller.openRoundoff,
                      // ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      const Text(
                        'App Version: 1.0.0',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        'Last Sync: ${controller.lastSyncText.value}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer(HomeController controller) {
    return Drawer(
      backgroundColor: AppColors.primaryVariant,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.accentGold,
                child: Icon(Icons.shield, color: AppColors.textOnLight),
              ),
              title: Text('Employee', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                'Role: Guard',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const Divider(color: Colors.white24),
            _drawerItem('Home', Icons.home, () => Get.back()),
            // TODO: Round-off module is temporarily disabled.
            // _drawerItem(
            //   'Round Off Activity',
            //   Icons.qr_code,
            //   controller.openRoundoff,
            // ),
            _drawerItem(
              'Employee Verification',
              Icons.verified,
              controller.openVerification,
            ),
            Obx(
              () => controller.role.value == 'admin'
                  ? _drawerItem(
                      'Admin Panel',
                      Icons.admin_panel_settings,
                      controller.openAdmin,
                    )
                  : const SizedBox.shrink(),
            ),
            _drawerItem('Logout', Icons.logout, controller.logout),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(String label, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: GlassCard(
        child: SizedBox(
          width: double.infinity,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, width: 56, height: 56),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
