import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';
import 'package:golstarsecurityapplatest/core/widgets/glass_card.dart';
import 'package:golstarsecurityapplatest/core/widgets/glass_input.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/presentation/controllers/verification_form_controller.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';

class EmpVerificationForm extends StatefulWidget {
  const EmpVerificationForm({super.key});

  @override
  State<EmpVerificationForm> createState() => _EmpVerificationFormState();
}

class _EmpVerificationFormState extends State<EmpVerificationForm> {
  bool showAadhaar = false;
  bool showPan = false;
  Timer? _aadhaarTimer;
  Timer? _panTimer;

  @override
  void dispose() {
    _aadhaarTimer?.cancel();
    _panTimer?.cancel();
    super.dispose();
  }

  // ── validators (optional fields: validate only when non-empty) ──────────
  String? _mobileValidator(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final digits = v.trim().replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) return 'Mobile number must be 10 digits';
    return null;
  }

  String? _pinValidator(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final digits = v.trim().replaceAll(RegExp(r'\D'), '');
    if (digits.length != 6) return 'PIN must be 6 digits';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VerificationFormController>();
    final emp = controller.employee.value;

    if (emp == null) {
      return const Scaffold(body: Center(child: Text('No employee selected')));
    }
    final isRefMandatory = emp.isReferenceMandatory;

    return Scaffold(
      appBar: AppBar(title: const Text('Verification Form')),
      body: WillPopScope(
        onWillPop: () => _handleBack(context, controller),
        child: Container(
          decoration:
              const BoxDecoration(gradient: AppColors.backgroundGradient),
          child: SafeArea(
            child: Obx(
              () => SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      // ── Employee Info ──────────────────────────────────
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Employee Info',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _infoRow('Name', emp.empName),
                            _infoRow('Code', emp.empCode),
                            _infoRow('Gender', emp.gender ?? ''),
                            _infoRow('Mobile', emp.mobileNo ?? ''),
                            _infoRow('Alt Mobile', emp.altMobileNo ?? ''),
                            _infoRow('Email Official', emp.emailOfficial ?? ''),
                            _infoRow('Email Personal', emp.emailPersonal ?? ''),
                            if ((emp.createdDate ?? '').trim().isNotEmpty)
                              _infoRow('Created', emp.createdDate ?? ''),
                            if ((emp.verificationDate ?? '').trim().isNotEmpty ||
                                (emp.verificationTimeSlot ?? '').trim().isNotEmpty)
                              _infoRow(
                                'Schedule',
                                '${(emp.verificationDate ?? '').trim()} ${(emp.verificationTimeSlot ?? '').trim()}',
                              ),
                            _infoRow(
                              'References',
                              isRefMandatory ? 'Mandatory' : 'Optional',
                            ),
                            _piiRow('Aadhaar', emp.aadhar ?? '', showAadhaar,
                                () {
                              setState(() => showAadhaar = true);
                              _aadhaarTimer?.cancel();
                              _aadhaarTimer = Timer(
                                const Duration(seconds: 5),
                                () {
                                  if (mounted)
                                    setState(() => showAadhaar = false);
                                },
                              );
                            }),
                            _piiRow('PAN', emp.pan ?? '', showPan, () {
                              setState(() => showPan = true);
                              _panTimer?.cancel();
                              _panTimer =
                                  Timer(const Duration(seconds: 5), () {
                                if (mounted) setState(() => showPan = false);
                              });
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Address Verification ───────────────────────────
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Address Verification',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${emp.add1 ?? ''} ${emp.add2 ?? ''} ${emp.city ?? ''} ${emp.state ?? ''} ${emp.pin ?? ''}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text(
                                  'Address Confirmed',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                const Spacer(),
                                Switch(
                                  value: controller.addressConfirmed.value,
                                  onChanged: (v) =>
                                      controller.addressConfirmed.value = v,
                                  activeColor: AppColors.accentGold,
                                ),
                              ],
                            ),
                            if (!controller.addressConfirmed.value) ...[
                              GlassInput(
                                controller: controller.newAdd1,
                                label: 'New Address Line 1',
                              ),
                              const SizedBox(height: 8),
                              GlassInput(
                                controller: controller.newAdd2,
                                label: 'New Address Line 2',
                              ),
                              const SizedBox(height: 8),
                              GlassInput(
                                controller: controller.newCity,
                                label: 'City',
                              ),
                              const SizedBox(height: 8),
                              GlassInput(
                                controller: controller.newState,
                                label: 'State',
                              ),
                              const SizedBox(height: 8),
                              // PIN: numeric keyboard, 6-digit validation
                              GlassInput(
                                controller: controller.newPin,
                                label: 'PIN',
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                validator: _pinValidator,
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: controller.captureGps,
                                  child: const Text('Capture GPS Location'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    controller.gps.value.isEmpty
                                        ? 'No GPS captured'
                                        : controller.gps.value,
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                ),
                                if (controller.gpsPosition.value != null)
                                  IconButton(
                                    onPressed: () =>
                                        _showGpsDetails(context, controller),
                                    icon: const Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: controller.capturePhoto,
                              child: const Text('Capture Employee Photo'),
                            ),
                            if (controller.employeePhoto.value != null) ...[
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  controller.employeePhoto.value!,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: controller.capturePhoto,
                                    icon: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                    ),
                                    tooltip: 'Recapture',
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        controller.employeePhoto.value = null,
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.redAccent,
                                    ),
                                    tooltip: 'Delete',
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── House & Family ─────────────────────────────────
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'House & Family',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GlassInput(
                              controller: controller.fatherName,
                              label: 'Father Name',
                            ),
                            const SizedBox(height: 8),
                            GlassInput(
                              controller: controller.motherName,
                              label: 'Mother Name',
                            ),
                            const SizedBox(height: 8),
                            GlassInput(
                              controller: controller.spouseName,
                              label: 'Spouse Name',
                            ),
                            const SizedBox(height: 8),
                            GlassInput(
                              controller: controller.brotherName,
                              label: 'Brother Name',
                            ),
                            const SizedBox(height: 8),
                            GlassInput(
                              controller: controller.sisterName,
                              label: 'Sister Name',
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text(
                                  'Children',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: controller.addChild,
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Obx(
                              () => Column(
                                children: List.generate(
                                  controller.children.length,
                                  (index) {
                                    final child = controller.children[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      // ── FIX: Stack wraps the outer container
                                      // so the close button sits on the top-right
                                      // corner of the whole card, not on the text field
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    12, 28, 12, 12),
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.06),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                  color: Colors.white24),
                                            ),
                                            child: Column(
                                              children: [
                                                GlassInput(
                                                  controller: child.name,
                                                  label: 'Child Name',
                                                ),
                                                const SizedBox(height: 8),
                                                LayoutBuilder(
                                                  builder:
                                                      (context, constraints) {
                                                    final total =
                                                        constraints.maxWidth;
                                                    final genderWidth =
                                                        total * 0.3;
                                                    final dobWidth = total * 0.7;
                                                    return Row(
                                                      children: [
                                                        SizedBox(
                                                          width: genderWidth,
                                                          child:
                                                              DropdownButtonFormField<
                                                                  String>(
                                                            value: child
                                                                .gender.value,
                                                            items: const [
                                                              DropdownMenuItem(
                                                                value: 'M',
                                                                child: Text('M'),
                                                              ),
                                                              DropdownMenuItem(
                                                                value: 'F',
                                                                child: Text('F'),
                                                              ),
                                                            ],
                                                            onChanged: (v) =>
                                                                child.gender
                                                                        .value =
                                                                    v ?? 'M',
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        SizedBox(
                                                          width: dobWidth - 8,
                                                          child: GlassInput(
                                                            controller:
                                                                child.dob,
                                                            label: 'DOB',
                                                            readOnly: true,
                                                            onTap: () =>
                                                                _pickChildDob(
                                                              context,
                                                              child.dob,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Close button anchored to top-right
                                          // of the card container with proper offset
                                          Positioned(
                                            top: 6,
                                            right: 6,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  controller.removeChild(index),
                                              child: Container(
                                                width: 26,
                                                height: 26,
                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent
                                                      .withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: Colors.redAccent
                                                        .withOpacity(0.4),
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 16,
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── References ─────────────────────────────────────
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isRefMandatory
                                  ? 'References (Mandatory)'
                                  : 'References',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GlassInput(
                              controller: controller.ref1Name,
                              label: 'Reference 1 Name',
                              validator: (v) {
                                final name = (v ?? '').trim();
                                final mobile =
                                    controller.ref1Mobile.text.trim();
                                if (isRefMandatory && name.isEmpty) {
                                  return 'Reference 1 name is required';
                                }
                                if (mobile.isNotEmpty && name.isEmpty) {
                                  return 'Enter Reference 1 name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            // Mobile: numeric keyboard + 10-digit validation
                            GlassInput(
                              controller: controller.ref1Mobile,
                              label: 'Reference 1 Mobile',
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (v) {
                                final mobile = (v ?? '').trim();
                                final name = controller.ref1Name.text.trim();
                                if (isRefMandatory && mobile.isEmpty) {
                                  return 'Reference 1 mobile is required';
                                }
                                if (name.isNotEmpty && mobile.isEmpty) {
                                  return 'Enter Reference 1 mobile';
                                }
                                return _mobileValidator(v);
                              },
                            ),
                            const SizedBox(height: 8),
                            GlassInput(
                              controller: controller.ref2Name,
                              label: 'Reference 2 Name',
                              validator: (v) {
                                final name = (v ?? '').trim();
                                final mobile =
                                    controller.ref2Mobile.text.trim();
                                if (mobile.isNotEmpty && name.isEmpty) {
                                  return 'Enter Reference 2 name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            GlassInput(
                              controller: controller.ref2Mobile,
                              label: 'Reference 2 Mobile',
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (v) {
                                final mobile = (v ?? '').trim();
                                final name = controller.ref2Name.text.trim();
                                if (name.isNotEmpty && mobile.isEmpty) {
                                  return 'Enter Reference 2 mobile';
                                }
                                return _mobileValidator(v);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Criminal Record ────────────────────────────────
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Criminal Record',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Any Criminal Cases?',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                const Spacer(),
                                Switch(
                                  value: controller.hasCriminal.value,
                                  onChanged: (v) =>
                                      controller.hasCriminal.value = v,
                                  activeColor: AppColors.accentGold,
                                ),
                              ],
                            ),
                            if (controller.hasCriminal.value)
                              GlassInput(
                                controller: controller.criminalDetails,
                                label: 'Criminal Details',
                                minLines: 3,
                                maxLines: 3,
                                textInputAction: TextInputAction.newline,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Signatures ─────────────────────────────────────
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Signatures',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Verifier Signature',
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 6),
                            _signatureField(
                              context,
                              label: 'Add verifier signature',
                              signatureController:
                                  controller.verifierSignature,
                              signatureImage:
                                  controller.verifierSignatureImage,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Employee Signature',
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 6),
                            _signatureField(
                              context,
                              label: 'Add employee signature',
                              signatureController:
                                  controller.employeeSignature,
                              signatureImage:
                                  controller.employeeSignatureImage,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Verification Decision ──────────────────────────
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Verification Decision',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                // ── Verified button: green when selected ──
                                Expanded(
                                  child: _decisionButton(
                                    label: 'Verified',
                                    icon: controller.status.value == 'Verified'
                                        ? Icons.check_circle
                                        : Icons.check_circle_outline,
                                    isSelected:
                                        controller.status.value == 'Verified',
                                    selectedColor: Colors.green.shade600,
                                    onTap: () =>
                                        controller.status.value = 'Verified',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // ── Rejected button: red when selected ────
                                Expanded(
                                  child: _decisionButton(
                                    label: 'Rejected',
                                    icon: controller.status.value == 'Rejected'
                                        ? Icons.cancel
                                        : Icons.cancel_outlined,
                                    isSelected:
                                        controller.status.value == 'Rejected',
                                    selectedColor: Colors.red.shade600,
                                    onTap: () =>
                                        controller.status.value = 'Rejected',
                                  ),
                                ),
                              ],
                            ),
                            // Status badge shown after selection
                            if (controller.status.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: controller.status.value == 'Verified'
                                        ? Colors.green.withOpacity(0.15)
                                        : Colors.red.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          controller.status.value == 'Verified'
                                              ? Colors.green.shade400
                                              : Colors.red.shade400,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        controller.status.value == 'Verified'
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        size: 16,
                                        color:
                                            controller.status.value == 'Verified'
                                                ? Colors.green.shade400
                                                : Colors.red.shade400,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        controller.status.value == 'Verified'
                                            ? 'Marked as Verified'
                                            : 'Marked as Rejected',
                                        style: TextStyle(
                                          color:
                                              controller.status.value ==
                                                      'Verified'
                                                  ? Colors.green.shade300
                                                  : Colors.red.shade300,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (controller.status.value == 'Rejected')
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: GlassInput(
                                  controller: controller.rejectionReason,
                                  label: 'Rejection Reason',
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          height: 64,
                          child: ElevatedButton(
                            onPressed: controller.isSubmitting.value
                                ? null
                                : controller.submit,
                            child: controller.isSubmitting.value
                                ? const CircularProgressIndicator(
                                    color: AppColors.primary,
                                  )
                                : const Text(
                                    'Submit Verification',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Decision button widget ───────────────────────────────────────────────
  Widget _decisionButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color selectedColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withOpacity(0.2)
              : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.white24,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 18,
                color: isSelected ? selectedColor : Colors.white70),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? selectedColor : Colors.white70,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(color: Colors.white70)),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _piiRow(
      String label, String value, bool show, VoidCallback onReveal) {
    String display;
    if (show) {
      display = value;
    } else {
      final clean = value.replaceAll(RegExp(r'\s+'), '');
      if (clean.length >= 4) {
        display = 'XXXX-XXXX-${clean.substring(clean.length - 4)}';
      } else {
        display = 'XXXX-XXXX-XXXX';
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(color: Colors.white70)),
          Expanded(
            child: Text(display, style: const TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: onReveal,
            child: const Text(
              'Reveal',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickChildDob(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 10, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: today,
      selectableDayPredicate: (date) {
        final d = DateTime(date.year, date.month, date.day);
        return !d.isAfter(today);
      },
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.accentGold,
              onPrimary: AppColors.primary,
              surface: AppColors.primaryVariant,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppColors.primaryVariant,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accentGold,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked == null) return;
    controller.text = DateFormat('yyyy-MM-dd').format(picked);
  }

  Widget _signatureField(
    BuildContext context, {
    required String label,
    required SignatureController signatureController,
    required Rx<Uint8List?> signatureImage,
  }) {
    return Obx(() {
      final image = signatureImage.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _openSignatureDialog(
              context,
              signatureController: signatureController,
              signatureImage: signatureImage,
            ),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              alignment: Alignment.center,
              child: image == null
                  ? Text(
                      label,
                      style: const TextStyle(color: Colors.white70),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                        image,
                        width: double.infinity,
                        height: 140,
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
          ),
          if (image != null)
            Row(
              children: [
                IconButton(
                  onPressed: () => _openSignatureDialog(
                    context,
                    signatureController: signatureController,
                    signatureImage: signatureImage,
                  ),
                  icon: const Icon(Icons.edit, color: Colors.white),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: () {
                    signatureController.clear();
                    signatureImage.value = null;
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  tooltip: 'Delete',
                ),
              ],
            ),
        ],
      );
    });
  }

  Future<bool> _handleBack(
    BuildContext context,
    VerificationFormController controller,
  ) async {
    if (controller.allowPopWithoutConfirm.value) {
      return true;
    }
    if (!_hasUnsavedChanges(controller)) {
      return true;
    }
    final discard = await _confirmDiscardDialog(context);
    if (discard == true) {
      controller.resetForm();
      controller.allowPopWithoutConfirm.value = true;
      return true;
    }
    return false;
  }

  bool _hasUnsavedChanges(VerificationFormController controller) {
    if (controller.employeePhoto.value != null) return true;
    if (controller.gps.value.isNotEmpty) return true;
    if (controller.status.value.isNotEmpty) return true;
    if (!controller.addressConfirmed.value) return true;
    if (controller.hasCriminal.value) return true;
    if (controller.verifierSignatureImage.value != null) return true;
    if (controller.employeeSignatureImage.value != null) return true;

    final fields = [
      controller.newAdd1,
      controller.newAdd2,
      controller.newCity,
      controller.newState,
      controller.newPin,
      controller.fatherName,
      controller.motherName,
      controller.spouseName,
      controller.brotherName,
      controller.sisterName,
      controller.ref1Name,
      controller.ref1Mobile,
      controller.ref2Name,
      controller.ref2Mobile,
      controller.criminalDetails,
      controller.rejectionReason,
    ];
    for (final c in fields) {
      if (c.text.trim().isNotEmpty) return true;
    }
    for (final child in controller.children) {
      if (child.name.text.trim().isNotEmpty) return true;
      if (child.dob.text.trim().isNotEmpty) return true;
    }
    return false;
  }

  Future<bool?> _confirmDiscardDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryVariant,
          title: const Text(
            'Discard changes?',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'If you leave now, all entered data will be lost.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Keep Editing'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openSignatureDialog(
    BuildContext context, {
    required SignatureController signatureController,
    required Rx<Uint8List?> signatureImage,
  }) async {
    final tempController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 3.5,
      exportBackgroundColor: Colors.white,
    );
    tempController.points = List<Point>.from(signatureController.points);

    final points = await showDialog<List<Point>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryVariant,
          title: const Text(
            'Draw Signature',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 320,
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Signature(
                controller: tempController,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => tempController.clear(),
              child: const Text('Clear'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context)
                  .pop(List<Point>.from(tempController.points)),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    tempController.dispose();

    if (points == null) return;
    if (points.isEmpty) {
      signatureController.clear();
      signatureImage.value = null;
      return;
    }
    signatureController.points = List<Point>.from(points);
    signatureImage.value = await signatureController.toPngBytes();
  }

  void _showGpsDetails(
    BuildContext context,
    VerificationFormController controller,
  ) {
    final position = controller.gpsPosition.value;
    if (position == null) return;
    final capturedAt = controller.gpsCapturedAt.value;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryVariant,
          title: const Text(
            'GPS Details',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Latitude: ${position.latitude}',
                  style: const TextStyle(color: Colors.white70)),
              Text('Longitude: ${position.longitude}',
                  style: const TextStyle(color: Colors.white70)),
              Text('Accuracy: ${position.accuracy} m',
                  style: const TextStyle(color: Colors.white70)),
              Text('Altitude: ${position.altitude} m',
                  style: const TextStyle(color: Colors.white70)),
              Text('Speed: ${position.speed} m/s',
                  style: const TextStyle(color: Colors.white70)),
              Text('Heading: ${position.heading}',
                  style: const TextStyle(color: Colors.white70)),
              if (capturedAt != null)
                Text('Captured: $capturedAt',
                    style: const TextStyle(color: Colors.white70)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
