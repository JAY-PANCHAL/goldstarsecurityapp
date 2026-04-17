import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/datasources/employee_local_datasource.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/datasources/employee_remote_datasource.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/datasources/verification_local_datasource.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/datasources/verification_remote_datasource.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/repositories/employee_repo_impl.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/data/repositories/verification_repo_impl.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/repositories/employee_repository.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/repositories/verification_repository.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/usecases/generate_verification_pdf_usecase.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/usecases/get_employees_usecase.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/domain/usecases/submit_verification_usecase.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/presentation/controllers/emp_list_controller.dart';
import 'package:golstarsecurityapplatest/features/employee_verification/presentation/controllers/verification_form_controller.dart';

class VerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeRemoteDatasource>(() => EmployeeRemoteDatasourceImpl());
    Get.lazyPut<EmployeeLocalDatasource>(() => EmployeeLocalDatasourceImpl());
    Get.lazyPut<EmployeeRepository>(
      () => EmployeeRepositoryImpl(remote: Get.find(), local: Get.find()),
    );

    Get.lazyPut<VerificationRemoteDatasource>(
      () => VerificationRemoteDatasourceImpl(),
    );
    Get.lazyPut<VerificationRepository>(
      () => VerificationRepositoryImpl(remote: Get.find()),
    );
    Get.lazyPut(() => VerificationLocalDatasource());

    Get.lazyPut(() => GetEmployeesUsecase(Get.find<EmployeeRepository>()));
    Get.lazyPut(
      () => SubmitVerificationUsecase(Get.find<VerificationRepository>()),
    );
    Get.lazyPut(() => GenerateVerificationPdfUsecase());

    Get.lazyPut(
      () => EmpListController(getEmployeesUsecase: Get.find()),
      fenix: true,
    );
    Get.lazyPut(
      () => VerificationFormController(
        submitUsecase: Get.find(),
        pdfUsecase: Get.find(),
        localDatasource: Get.find(),
        employeeRepository: Get.find(),
      ),
      fenix: true,
    );
  }
}
