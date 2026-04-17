import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/app/bindings/auth_binding.dart';
import 'package:golstarsecurityapplatest/app/bindings/admin_binding.dart';
import 'package:golstarsecurityapplatest/app/bindings/home_binding.dart';
import 'package:golstarsecurityapplatest/app/bindings/roundoff_binding.dart';
import 'package:golstarsecurityapplatest/app/bindings/splash_binding.dart';
import 'package:golstarsecurityapplatest/app/bindings/verification_binding.dart';
import 'package:golstarsecurityapplatest/app/routes/app_routes.dart';
import 'package:golstarsecurityapplatest/features/admin/presentation/views/admin_dashboard.dart';
import 'package:golstarsecurityapplatest/features/admin/presentation/views/manage_security_team.dart';
import 'package:golstarsecurityapplatest/features/admin/presentation/views/manage_buildings.dart';
import 'package:golstarsecurityapplatest/features/admin/presentation/views/manage_floors.dart';
import 'package:golstarsecurityapplatest/features/admin/presentation/views/manage_checkpoints.dart';
import 'package:golstarsecurityapplatest/features/admin/presentation/views/manage_schedules.dart';
import 'package:golstarsecurityapplatest/features/admin/presentation/views/assign_schedule.dart';
import 'package:golstarsecurityapplatest/features/admin/presentation/views/roundoff_report.dart';
import 'package:golstarsecurityapplatest/features/auth/presentation/views/login_screen.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/presentation/views/emp_verification_landing.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/presentation/views/emp_verification_form.dart';
import 'package:golstarsecurityapplatest/features/home/presentation/views/landing_page.dart';
import 'package:golstarsecurityapplatest/features/roundoff/presentation/views/roundoff_landing.dart';
import 'package:golstarsecurityapplatest/features/roundoff/presentation/views/roundoff_activity.dart';
import 'package:golstarsecurityapplatest/features/splash/presentation/views/splash_screen.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.landing,
      page: () => const LandingPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.verificationLanding,
      page: () => const EmpVerificationLanding(),
      binding: VerificationBinding(),
    ),
    GetPage(
      name: AppRoutes.verificationForm,
      page: () => const EmpVerificationForm(),
      binding: VerificationBinding(),
    ),
    GetPage(
      name: AppRoutes.roundoffLanding,
      page: () => const RoundoffLanding(),
      binding: RoundoffBinding(),
    ),
    GetPage(
      name: AppRoutes.roundoffActivity,
      page: () => const RoundoffActivity(),
      binding: RoundoffBinding(),
    ),
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const AdminDashboard(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminSecurityTeam,
      page: () => const ManageSecurityTeam(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminBuildings,
      page: () => const ManageBuildings(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminFloors,
      page: () => const ManageFloors(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminCheckpoints,
      page: () => const ManageCheckpoints(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminSchedules,
      page: () => const ManageSchedules(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminAssignSchedule,
      page: () => const AssignSchedule(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.adminReport,
      page: () => const RoundoffReport(),
      binding: AdminBinding(),
    ),
  ];
}
