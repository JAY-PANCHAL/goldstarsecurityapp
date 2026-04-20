import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/constants/asset_paths.dart';
import 'package:golstarsecurityapplatest/app/constants/app_strings.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';
import 'package:golstarsecurityapplatest/core/utils/validators.dart';
import 'package:golstarsecurityapplatest/core/widgets/glass_button.dart';
import 'package:golstarsecurityapplatest/core/widgets/glass_card.dart';
import 'package:golstarsecurityapplatest/core/widgets/glass_input.dart';
import 'package:golstarsecurityapplatest/core/widgets/loading_overlay.dart';
import 'package:golstarsecurityapplatest/features/auth/presentation/controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Obx(
      () => LoadingOverlay(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.backgroundGradient,
                ),
              ),
              Image.asset(
                AssetPaths.loginBackground,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(AssetPaths.logo, width: 80, height: 80),
                      const SizedBox(height: 12),
                      const Text(
                        AppStrings.appName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      GlassCard(
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Security Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 16),
                              GlassInput(
                                controller: controller.usernameController,
                                label: 'Employee Code / Username',
                                validator: Validators.username,
                              ),
                              const SizedBox(height: 12),
                              Obx(
                                () => GlassInput(
                                  controller: controller.passwordController,
                                  label: 'Password',
                                  obscureText: controller.obscurePassword.value,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.obscurePassword.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white70,
                                    ),
                                    onPressed: controller.togglePassword,
                                  ),
                                  validator: (value) =>
                                      Validators.requiredField(
                                        value,
                                        message: 'Password is required',
                                      ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              GlassButton(
                                label: 'Login',
                                onPressed: controller.login,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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
}
