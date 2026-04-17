class RoundoffScheduleModel {
  final String code;
  final String? sgCode;
  final String rDate;
  final String rTime;
  final String buildingCode;
  final String buildingName;
  final String floorCode;
  final String floorName;
  final int checkPointCount;
  final String status;
  final String? startDateTime;
  final String? endDateTime;
  final int scannedCPCount;
  final String? remarks;

  RoundoffScheduleModel({
    required this.code,
    required this.rDate,
    required this.rTime,
    required this.buildingCode,
    required this.buildingName,
    required this.floorCode,
    required this.floorName,
    required this.checkPointCount,
    this.sgCode,
    this.status = 'Pending',
    this.startDateTime,
    this.endDateTime,
    this.scannedCPCount = 0,
    this.remarks,
  });

  factory RoundoffScheduleModel.fromDb(Map<String, dynamic> map) =>
      RoundoffScheduleModel(
        code: map['code'],
        sgCode: map['sgCode'],
        rDate: map['rDate'],
        rTime: map['rTime'],
        buildingCode: map['buildingCode'],
        buildingName: map['buildingName'],
        floorCode: map['floorCode'],
        floorName: map['floorName'],
        checkPointCount: map['checkPointCount'] ?? 0,
        status: map['status'] ?? 'Pending',
        startDateTime: map['startDateTime'],
        endDateTime: map['endDateTime'],
        scannedCPCount: map['scannedCPCount'] ?? 0,
        remarks: map['remarks'],
      );
}
