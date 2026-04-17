class EmployeeEntity {
  final int employeeId;
  final String empCode;
  final String empName;
  final String? status;
  final String? verifiedDate;
  final String? createdDate;
  final bool isReferenceMandatory;
  final String? verificationDate;
  final String? verificationTimeSlot;
  final String? mobileNo;
  final String? altMobileNo;
  final String? emailOfficial;
  final String? emailPersonal;
  final String? add1;
  final String? add2;
  final String? city;
  final String? state;
  final String? pin;
  final String? aadhar;
  final String? gender;
  final String? pan;
  final String? spouseName;
  final String? fatherName;

  EmployeeEntity({
    required this.employeeId,
    required this.empCode,
    required this.empName,
    this.status,
    this.verifiedDate,
    this.createdDate,
    this.isReferenceMandatory = false,
    this.verificationDate,
    this.verificationTimeSlot,
    this.mobileNo,
    this.altMobileNo,
    this.emailOfficial,
    this.emailPersonal,
    this.add1,
    this.add2,
    this.city,
    this.state,
    this.pin,
    this.aadhar,
    this.gender,
    this.pan,
    this.spouseName,
    this.fatherName,
  });
}
