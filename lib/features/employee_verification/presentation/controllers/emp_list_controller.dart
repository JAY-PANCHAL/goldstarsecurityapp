import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/core/widgets/error_snackbar.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/entities/employee_entity.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/usecases/get_employees_usecase.dart';
import 'package:intl/intl.dart';

class EmpListController extends GetxController {
  final GetEmployeesUsecase getEmployeesUsecase;

  EmpListController({required this.getEmployeesUsecase});

  final RxList<EmployeeEntity> pending = <EmployeeEntity>[].obs;
  final RxList<Map<String, dynamic>> verified = <Map<String, dynamic>>[].obs;
  final RxString query = ''.obs;
  final RxBool isLoading = false.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    searchController.text = query.value;
    refreshFromServer();
  }

  DateTime? _parseApiDateTime(String? raw) {
    if (raw == null) return null;
    final s = raw.trim();
    if (s.isEmpty) return null;
    final iso = DateTime.tryParse(s);
    if (iso != null) return iso;
    try {
      return DateFormat('yyyy-MM-dd HH:mm:ss').parseStrict(s);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadFromApi() async {
    final pendingList = await getEmployeesUsecase.getPending();
    final verifiedList = await getEmployeesUsecase.getVerified();
    pendingList.sort((a, b) {
      final ad = _parseApiDateTime(a.createdDate);
      final bd = _parseApiDateTime(b.createdDate);
      if (ad != null && bd != null) return bd.compareTo(ad);
      if (bd != null) return 1;
      if (ad != null) return -1;
      return a.empName.compareTo(b.empName);
    });

    verifiedList.sort((a, b) {
      final ad = _parseApiDateTime(a['createdDate']?.toString()) ??
          _parseApiDateTime(a['verificationDateTime']?.toString());
      final bd = _parseApiDateTime(b['createdDate']?.toString()) ??
          _parseApiDateTime(b['verificationDateTime']?.toString());
      if (ad != null && bd != null) return bd.compareTo(ad);
      if (bd != null) return 1;
      if (ad != null) return -1;
      return (a['empName'] ?? '').toString().compareTo(
            (b['empName'] ?? '').toString(),
          );
    });

    pending.assignAll(pendingList);
    verified.assignAll(verifiedList);
  }

  Future<void> refreshFromServer() async {
    isLoading.value = true;
    try {
      await loadFromApi();
    } catch (e) {
      ErrorSnackbar.show('Unable to refresh employees');
    } finally {
      isLoading.value = false;
    }
  }

  List<EmployeeEntity> get filteredPending {
    final q = query.value.toLowerCase();
    if (q.isEmpty) return pending;
    return pending.where((e) {
      return e.empName.toLowerCase().contains(q) ||
          e.empCode.toLowerCase().contains(q) ||
          (e.mobileNo ?? '').toLowerCase().contains(q) ||
          (e.city ?? '').toLowerCase().contains(q);
    }).toList();
  }

  List<Map<String, dynamic>> get filteredVerified {
    final q = query.value.toLowerCase();
    if (q.isEmpty) return verified;
    return verified.where((e) {
      return (e['empName'] ?? '').toString().toLowerCase().contains(q) ||
          (e['empCode'] ?? '').toString().toLowerCase().contains(q) ||
          (e['mobileNo'] ?? '').toString().toLowerCase().contains(q) ||
          (e['city'] ?? '').toString().toLowerCase().contains(q);
    }).toList();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
