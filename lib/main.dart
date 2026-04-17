import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/bindings/initial_binding.dart';
import 'package:golstarsecurityapplatest/app/routes/app_pages.dart';
import 'package:golstarsecurityapplatest/app/routes/app_routes.dart';
import 'package:golstarsecurityapplatest/app/themes/app_theme.dart';

void main() {
  runApp(const GoldStarApp());
}

class GoldStarApp extends StatelessWidget {
  const GoldStarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GoldStar Security',
      theme: AppTheme.light(),
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
