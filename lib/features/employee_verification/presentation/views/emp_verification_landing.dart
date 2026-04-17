import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';
import 'package:golstarsecurityapplatest/core/widgets/glass_card.dart';
import 'package:golstarsecurityapplatest/core/widgets/glass_input.dart';
import 'package:golstarsecurityapplatest/core/widgets/pii_text.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/presentation/controllers/emp_list_controller.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/presentation/controllers/verification_form_controller.dart';
import 'package:golstarsecurityapplatest/app/routes/app_routes.dart';

class EmpVerificationLanding extends StatelessWidget {
  const EmpVerificationLanding({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmpListController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Employee Verification')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Obx(
            () => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GlassInput(
                    controller: controller.searchController,
                    label: 'Search by name, code, mobile, city',
                    suffixIcon: const Icon(Icons.search, color: Colors.white70),
                    validator: (_) => null,
                    onChanged: (value) => controller.query.value = value,
                  ),
                ),
                if (controller.isLoading.value &&
                    controller.pending.isEmpty &&
                    controller.verified.isEmpty)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          const TabBar(
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            labelColor: AppColors.accentGold,
                            unselectedLabelColor: Colors.white70,
                            tabs: [
                              Tab(text: 'Pending'),
                              Tab(text: 'Verified'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                _PendingList(controller: controller),
                                _VerifiedList(controller: controller),
                              ],
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.refreshFromServer,
        backgroundColor: AppColors.accentGold,
        child: const Icon(Icons.refresh, color: AppColors.textOnLight),
      ),
    );
  }
}

class _PendingList extends StatelessWidget {
  final EmpListController controller;

  const _PendingList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.filteredPending;
      if (list.isEmpty) {
        return const Center(
          child: Text(
            'No pending employees',
            style: TextStyle(color: Colors.white70),
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: controller.refreshFromServer,
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final e = list[index];
            return InkWell(
              onTap: () => _showEmployeeSheet(context, e),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.empName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          e.empCode,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Mobile: ${e.mobileNo ?? ''} | City: ${e.city ?? ''}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text(
                          'Aadhaar: ',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        PiiText(
                          value: e.aadhar,
                          isAadhaar: true,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          'PAN: ',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        PiiText(
                          value: e.pan,
                          isAadhaar: false,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    if ((e.createdDate ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Created: ${e.createdDate}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    if ((e.verificationDate ?? '').trim().isNotEmpty ||
                        (e.verificationTimeSlot ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Schedule: ${(e.verificationDate ?? '').trim()} ${(e.verificationTimeSlot ?? '').trim()}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 2),
                    Text(
                      'References: ${e.isReferenceMandatory ? 'Mandatory' : 'Optional'}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemCount: list.length,
        ),
      );
    });
  }

  void _showEmployeeSheet(BuildContext context, dynamic e) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.primaryVariant,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                e.empName,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'EmpCode: ${e.empCode}',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                'Mobile: ${e.mobileNo ?? ''}',
                style: const TextStyle(color: Colors.white70),
              ),
              if ((e.createdDate ?? '').trim().isNotEmpty)
                Text(
                  'Created: ${e.createdDate}',
                  style: const TextStyle(color: Colors.white70),
                ),
              if ((e.verificationDate ?? '').trim().isNotEmpty ||
                  (e.verificationTimeSlot ?? '').trim().isNotEmpty)
                Text(
                  'Schedule: ${(e.verificationDate ?? '').trim()} ${(e.verificationTimeSlot ?? '').trim()}',
                  style: const TextStyle(color: Colors.white70),
                ),
              Text(
                'References: ${e.isReferenceMandatory ? 'Mandatory' : 'Optional'}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Get.find<VerificationFormController>().setEmployee(e);
                  Get.back();
                  Get.toNamed(AppRoutes.verificationForm);
                },
                child: const Text('Start Verification'),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VerifiedList extends StatelessWidget {
  final EmpListController controller;

  const _VerifiedList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.filteredVerified;
      if (list.isEmpty) {
        return const Center(
          child: Text(
            'No verified employees',
            style: TextStyle(color: Colors.white70),
          ),
        );
      }
      return ListView.separated(
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final e = list[index];
          return GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        e['empName'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Verified on ${e['verificationDateTime'] ?? ''}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                if ((e['createdDate'] ?? '').toString().trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Created: ${e['createdDate']}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: list.length,
      );
    });
  }
}
