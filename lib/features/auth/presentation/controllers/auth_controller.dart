import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/routes/app_routes.dart';
import 'package:golstarsecurityapplatest/core/network/api_exceptions.dart';
import 'package:golstarsecurityapplatest/core/services/session_manager.dart';
import 'package:golstarsecurityapplatest/core/services/sync_service.dart';
import 'package:golstarsecurityapplatest/core/widgets/error_snackbar.dart';
import 'package:golstarsecurityapplatest/features/auth/domain/usecases/login_usecase.dart';

class AuthController extends GetxController {
  final LoginUsecase loginUsecase;
  final SyncService syncService;

  AuthController({required this.loginUsecase, required this.syncService});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  void togglePassword() => obscurePassword.value = !obscurePassword.value;

  Future<void> login() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    isLoading.value = true;
    try {
      final user = await loginUsecase(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      await SessionManager.saveSession(
        accessToken: user.accessToken,
        refreshToken: user.refreshToken,
        employeeId: user.employeeId,
      );

      await syncService.sync();
      Get.offAllNamed(AppRoutes.landing);
    } on ApiException catch (e) {
      ErrorSnackbar.show(e.message);
    } catch (_) {
      ErrorSnackbar.show('Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
