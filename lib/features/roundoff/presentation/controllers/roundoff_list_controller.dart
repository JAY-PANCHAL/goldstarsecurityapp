import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/core/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:golstarsecurityapplatest/features/roundoff/data/datasources/roundoff_local_datasource.dart';
import 'package:golstarsecurityapplatest/features/roundoff/data/models/roundoff_schedule_model.dart';

class RoundoffListController extends GetxController {
  final RoundoffLocalDatasource localDatasource;
  final NotificationService notificationService =
      Get.find<NotificationService>();

  RoundoffListController({required this.localDatasource});

  final RxList<RoundoffScheduleModel> schedules = <RoundoffScheduleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSchedules();
  }

  Future<void> loadSchedules() async {
    final list = await localDatasource.getSchedules();
    schedules.assignAll(list);
    for (var i = 0; i < list.length; i++) {
      final item = list[i];
      try {
        final dateTime = DateFormat(
          'dd/MM/yyyy HH:mm',
        ).parse('${item.rDate} ${item.rTime}');
        await notificationService.scheduleRoundoff(
          id: i + 1,
          title: 'Time for Round Off — ${item.buildingName} at ${item.rTime}',
          scheduledAt: dateTime,
        );
      } catch (_) {
        // ignore parse errors
      }
    }
  }
}
