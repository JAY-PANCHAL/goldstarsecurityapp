import 'package:get/get.dart';
import 'package:golstarsecurityapplatest/features/roundoff/data/datasources/roundoff_local_datasource.dart';
import 'package:intl/intl.dart';

class RoundoffActivityController extends GetxController {
  final RoundoffLocalDatasource localDatasource;

  RoundoffActivityController({required this.localDatasource});

  final RxString roundoffCode = ''.obs;
  final RxInt scannedCount = 0.obs;
  final RxString status = 'Pending'.obs;

  void startRoundoff(String code) {
    roundoffCode.value = code;
    status.value = 'In Progress';
    localDatasource.updateScheduleStatus(
      code,
      'In Progress',
      start: DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
    );
  }

  Future<void> scanCheckpoint(String cpCode) async {
    if (roundoffCode.value.isEmpty) return;
    final exists = await localDatasource.isCheckpointScanned(
      roundoffCode.value,
      cpCode,
    );
    if (exists) return;
    await localDatasource.addCheckpointScan(
      roundoffCode.value,
      cpCode,
      DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
    );
    scannedCount.value = scannedCount.value + 1;
  }

  Future<void> completeRoundoff({String? remarks}) async {
    if (roundoffCode.value.isEmpty) return;
    status.value = 'Completed';
    await localDatasource.updateScheduleStatus(
      roundoffCode.value,
      'Completed',
      end: DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
      scanned: scannedCount.value,
    );
  }
}
