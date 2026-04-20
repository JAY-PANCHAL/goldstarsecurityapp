import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/core/network/api_exceptions.dart';
import 'package:golstarsecurityapplatest/core/utils/file_utils.dart';
import 'package:golstarsecurityapplatest/core/widgets/error_snackbar.dart';
import 'package:golstarsecurityapplatest/core/widgets/success_snackbar.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/datasources/verification_local_datasource.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/entities/employee_entity.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/repositories/employee_repository.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/usecases/generate_verification_pdf_usecase.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/usecases/submit_verification_usecase.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/presentation/controllers/emp_list_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';

class ChildInfo {
  final TextEditingController name = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final RxString gender = 'M'.obs;

  void dispose() {
    name.dispose();
    dob.dispose();
  }
}

class VerificationFormController extends GetxController {
  final SubmitVerificationUsecase submitUsecase;
  final GenerateVerificationPdfUsecase pdfUsecase;
  final VerificationLocalDatasource localDatasource;
  final EmployeeRepository employeeRepository;

  VerificationFormController({
    required this.submitUsecase,
    required this.pdfUsecase,
    required this.localDatasource,
    required this.employeeRepository,
  });

  final formKey = GlobalKey<FormState>();
  final Rx<EmployeeEntity?> employee = Rx<EmployeeEntity?>(null);

  // Address confirmation
  final RxBool addressConfirmed = true.obs;
  final newAdd1 = TextEditingController();
  final newAdd2 = TextEditingController();
  final newCity = TextEditingController();
  final newState = TextEditingController();
  final RxString selectedNewState = ''.obs;
  final newPin = TextEditingController();

  // GPS
  final RxString gps = ''.obs;
  final Rx<Position?> gpsPosition = Rx<Position?>(null);
  final Rx<DateTime?> gpsCapturedAt = Rx<DateTime?>(null);

  // Family details
  final fatherName = TextEditingController();
  final motherName = TextEditingController();
  final spouseName = TextEditingController();
  final brotherName = TextEditingController();
  final sisterName = TextEditingController();
  final RxList<ChildInfo> children = <ChildInfo>[].obs;

  // References
  final ref1Name = TextEditingController();
  final ref1Mobile = TextEditingController();
  final ref2Name = TextEditingController();
  final ref2Mobile = TextEditingController();

  // Criminal record
  final RxBool hasCriminal = false.obs;
  final criminalDetails = TextEditingController();

  // Decision
  final RxString status = ''.obs;
  final rejectionReason = TextEditingController();

  // Images and signatures
  final RxList<Uint8List> employeePhotos = <Uint8List>[].obs;
  final RxString homeType = ''.obs;
  final SignatureController verifierSignature = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 3.5,
    exportBackgroundColor: Colors.white,
  );
  final SignatureController employeeSignature = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 3.5,
    exportBackgroundColor: Colors.white,
  );
  final Rx<Uint8List?> verifierSignatureImage = Rx<Uint8List?>(null);
  final Rx<Uint8List?> employeeSignatureImage = Rx<Uint8List?>(null);

  final RxBool isSubmitting = false.obs;
  final RxBool allowPopWithoutConfirm = false.obs;

  void setEmployee(EmployeeEntity entity) {
    resetForm();
    employee.value = entity;
    fatherName.text = _apiValueOrEmpty(entity.fatherName);
    spouseName.text = _apiValueOrEmpty(entity.spouseName);
    homeType.value = _apiValueOrEmpty(entity.homeType);
  }

  String _apiValueOrEmpty(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty || v == '-') return '';
    return v;
  }

  void addChild() {
    if (children.length >= 5) return;
    children.add(ChildInfo());
  }

  void removeChild(int index) {
    children[index].dispose();
    children.removeAt(index);
  }

  Future<void> captureGps() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ErrorSnackbar.show('Location permission denied');
      return;
    }
    final position = await Geolocator.getCurrentPosition();
    gps.value = '${position.latitude}, ${position.longitude}';
    gpsPosition.value = position;
    gpsCapturedAt.value = DateTime.now();
  }

  Future<void> capturePhoto() async {
    if (employeePhotos.length >= 5) {
      ErrorSnackbar.show('Maximum 5 photos allowed');
      return;
    }
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (image == null) return;
    employeePhotos.add(await image.readAsBytes());
  }

  void removeEmployeePhoto(int index) {
    if (index < 0 || index >= employeePhotos.length) return;
    employeePhotos.removeAt(index);
  }

  void setNewState(String value) {
    selectedNewState.value = value;
    newState.text = value;
  }

  Future<void> submit() async {
    if (isSubmitting.value) return;
    if (employee.value == null) return;
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (status.value.isEmpty) {
      ErrorSnackbar.show('Please select verification status');
      return;
    }
    // References: prevent half-filled rows in all cases
    final r1Name = ref1Name.text.trim();
    final r1Mobile = ref1Mobile.text.trim();
    if ((r1Name.isEmpty) != (r1Mobile.isEmpty)) {
      ErrorSnackbar.show('Reference 1 name and mobile must both be filled');
      return;
    }
    final r2Name = ref2Name.text.trim();
    final r2Mobile = ref2Mobile.text.trim();
    if ((r2Name.isEmpty) != (r2Mobile.isEmpty)) {
      ErrorSnackbar.show('Reference 2 name and mobile must both be filled');
      return;
    }
    if (employee.value!.isReferenceMandatory) {
      if (r1Name.isEmpty || r1Mobile.isEmpty) {
        ErrorSnackbar.show('Reference 1 name and mobile are required');
        return;
      }
    }
    if (!addressConfirmed.value) {
      if (newAdd1.text.trim().isEmpty ||
          newCity.text.trim().isEmpty ||
          newState.text.trim().isEmpty ||
          newPin.text.trim().isEmpty) {
        ErrorSnackbar.show('New address is required when not confirmed');
        return;
      }
    }
    if (status.value == 'Rejected' && rejectionReason.text.trim().isEmpty) {
      ErrorSnackbar.show('Rejection reason is required');
      return;
    }
    if (fatherName.text.trim().isEmpty && motherName.text.trim().isEmpty) {
      ErrorSnackbar.show('Father or Mother name required');
      return;
    }

    final verifierSig = await verifierSignature.toPngBytes();
    final employeeSig = await employeeSignature.toPngBytes();
    if (verifierSig == null || employeeSig == null) {
      ErrorSnackbar.show('Both signatures are required');
      return;
    }

    isSubmitting.value = true;
    String pdfFilePath = '';
    try {
      final data = _buildPdfData();
      final pdfFile = await pdfUsecase(
        data: data,
        employeeName: employee.value!.empName,
        employeePhotos: employeePhotos.toList(),
        verifierSignature: verifierSig,
        employeeSignature: employeeSig,
        createdDate: employee.value!.createdDate,
        verifiedDate: employee.value!.verifiedDate,
        verificationDate: employee.value!.verificationDate,
        verificationTimeSlot: employee.value!.verificationTimeSlot,
      );
      pdfFilePath = pdfFile.path;

      final size = await FileUtils.fileSize(pdfFile);
      if (size > 5 * 1024 * 1024) {
        ErrorSnackbar.show('PDF exceeds 5MB limit');
        return;
      }

      // Submit to API — result carries the real server message + status code
      final result = await submitUsecase(
        employeeId: employee.value!.employeeId,
        status: status.value,
        pdfFile: pdfFile,
      );

      // Mark verified locally — run in background so a local DB error
      // never blocks the success path
      employeeRepository
          .markVerified(
            employee.value!.employeeId,
            DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
          )
          .catchError((_) {});

      // Navigate back first so the snackbar appears on the list screen
      allowPopWithoutConfirm.value = true;
      Get.back();

      // Small delay so navigation completes before the snackbar is queued,
      // then show the actual message the server returned
      await Future.delayed(const Duration(milliseconds: 300));
      SuccessSnackbar.show(result.message);

      // Refresh list via API so all server-side changes are visible
      if (Get.isRegistered<EmpListController>()) {
        Get.find<EmpListController>().refreshFromServer();
      }
    } on ApiException catch (e) {
      // Save locally for re-sync when online
      await localDatasource.addPending(
        employeeId: employee.value!.employeeId,
        status: status.value,
        pdfPath: pdfFilePath,
        rejectionReason: rejectionReason.text.trim(),
      );
      // Show the real API error message with status code
      ErrorSnackbar.show('[${e.statusCode}] ${e.message}');
    } catch (e) {
      ErrorSnackbar.show('Submission failed: ${e.toString()}');
    } finally {
      isSubmitting.value = false;
    }
  }

  Map<String, dynamic> _buildPdfData() {
    final emp = employee.value!;
    String safeText(String? value) {
      final v = (value ?? '').replaceAll('—', '-').trim();
      return v.isEmpty ? '-' : v;
    }

    String safeBool(bool value) => value ? 'Yes' : 'No';

    final childrenText = children.isEmpty
        ? '-'
        : children
            .map(
              (c) =>
                  '${safeText(c.name.text)} (${safeText(c.gender.value)}) ${safeText(c.dob.text)}',
            )
            .join(', ');
    return {
      'employeeDetails': {
        'Employee Name': safeText(emp.empName),
        'Employee Code': safeText(emp.empCode),
        'Gender': safeText(emp.gender),
        'Mobile': safeText(emp.mobileNo),
        'Alt Mobile': safeText(emp.altMobileNo),
        'Email Official': safeText(emp.emailOfficial),
        'Aadhaar': safeText(emp.aadhar),
        'PAN': safeText(emp.pan),
        'Age': safeText(emp.age),
      },
      'addressDetails': {
        'Address Confirmed': safeBool(addressConfirmed.value),
        'Old Address':
            safeText('${emp.add1 ?? ''} ${emp.add2 ?? ''} ${emp.city ?? ''} ${emp.state ?? ''} ${emp.pin ?? ''}'),
        'New Address': addressConfirmed.value
            ? '-'
            : safeText(
                '${newAdd1.text} ${newAdd2.text} ${newCity.text} ${newState.text} ${newPin.text}',
              ),
        'GPS': safeText(gps.value),
        'Home Type': safeText(homeType.value),
      },
      'familyDetails': {
        'Father': safeText(fatherName.text),
        'Mother': safeText(motherName.text),
        'Spouse': safeText(spouseName.text),
        'Brother': safeText(brotherName.text),
        'Sister': safeText(sisterName.text),
        'Children': childrenText,
      },
      'references': {
        'Ref1': safeText(
          '${ref1Name.text} - ${ref1Mobile.text}',
        ),
        'Ref2': safeText(
          '${ref2Name.text} - ${ref2Mobile.text}',
        ),
      },
      'criminalRecord': {
        'Has Criminal Cases': safeBool(hasCriminal.value),
        'Details': safeText(criminalDetails.text),
      },
      'decision': {
        'Status': safeText(status.value),
        'Rejection Reason': safeText(rejectionReason.text),
      },
    };
  }

  void resetForm() {
    addressConfirmed.value = true;
    newAdd1.clear();
    newAdd2.clear();
    newCity.clear();
    newState.clear();
    selectedNewState.value = '';
    newPin.clear();

    gps.value = '';
    gpsPosition.value = null;
    gpsCapturedAt.value = null;

    fatherName.clear();
    motherName.clear();
    spouseName.clear();
    brotherName.clear();
    sisterName.clear();

    for (final child in children) {
      child.dispose();
    }
    children.clear();

    ref1Name.clear();
    ref1Mobile.clear();
    ref2Name.clear();
    ref2Mobile.clear();

    hasCriminal.value = false;
    criminalDetails.clear();

    status.value = '';
    rejectionReason.clear();

    employeePhotos.clear();
    homeType.value = '';
    verifierSignature.clear();
    employeeSignature.clear();
    verifierSignatureImage.value = null;
    employeeSignatureImage.value = null;

    isSubmitting.value = false;
    allowPopWithoutConfirm.value = false;
  }

  @override
  void onClose() {
    newAdd1.dispose();
    newAdd2.dispose();
    newCity.dispose();
    newState.dispose();
    newPin.dispose();
    fatherName.dispose();
    motherName.dispose();
    spouseName.dispose();
    brotherName.dispose();
    sisterName.dispose();
    ref1Name.dispose();
    ref1Mobile.dispose();
    ref2Name.dispose();
    ref2Mobile.dispose();
    criminalDetails.dispose();
    rejectionReason.dispose();
    for (final child in children) {
      child.dispose();
    }
    verifierSignature.dispose();
    employeeSignature.dispose();
    super.onClose();
  }
}
