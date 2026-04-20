class EmployeeModel {
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
  final String? age;
  final String? homeType;
  final String? spouseName;
  final String? fatherName;

  EmployeeModel({
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
    this.age,
    this.homeType,
    this.spouseName,
    this.fatherName,
  });

  static String? _trimOrNull(dynamic value) {
    final s = value?.toString();
    if (s == null) return null;
    final t = s.trim();
    return t.isEmpty ? null : t;
  }

  static bool _boolFromApi(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value == 1;
    final s = value?.toString().trim().toLowerCase();
    return s == 'true' || s == '1' || s == 'yes' || s == 'y';
  }

  static String? _firstNonEmpty(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = _trimOrNull(json[key]);
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        employeeId: json['EmployeeID'],
        empCode: _trimOrNull(json['EmpCode']) ?? '',
        empName: _trimOrNull(json['EmpName']) ?? '',
        status: _trimOrNull(json['Status']),
        verifiedDate: _trimOrNull(json['VerifiedDate']),
        createdDate: _trimOrNull(json['CreatedDate']),
        isReferenceMandatory: _boolFromApi(json['IsReferenceMandatory']),
        verificationDate: _trimOrNull(json['VerificationDate']),
        verificationTimeSlot: _trimOrNull(json['VerificationTimeSlot']),
        mobileNo: _firstNonEmpty(json, const ['MobileNo', 'Mobile', 'MobNo']),
        altMobileNo:
            _firstNonEmpty(json, const ['AltMobileNo', 'AlternateMobileNo']),
        emailOfficial: _firstNonEmpty(
          json,
          const ['EmailOfficial', 'OfficialEmail', 'EmailID', 'Email'],
        ),
        emailPersonal: _firstNonEmpty(
          json,
          const ['EmailPersonal', 'PersonalEmail', 'EmailIdPersonal'],
        ),
        add1: _trimOrNull(json['Add1']),
        add2: _trimOrNull(json['Add2']),
        city: _trimOrNull(json['City']),
        state: _trimOrNull(json['State']),
        pin: _trimOrNull(json['Pin']),
        aadhar: _trimOrNull(json['Aadhar']),
        gender: _trimOrNull(json['Gender']),
        pan: _trimOrNull(json['PAN']),
        age: _firstNonEmpty(json, const ['Age', 'EmpAge']),
        homeType: _firstNonEmpty(
          json,
          const ['HomeType', 'ResidenceType', 'HomeStatus'],
        ),
        spouseName: _trimOrNull(json['SpouseName']),
        fatherName: _trimOrNull(json['FatherName']),
      );

  Map<String, dynamic> toDbMap({
    bool isVerified = false,
    String? verificationDateTime,
  }) => {
    'employeeId': employeeId,
    'empCode': empCode,
    'empName': empName,
    'mobileNo': mobileNo,
    'altMobileNo': altMobileNo,
    'emailOfficial': emailOfficial,
    'emailPersonal': emailPersonal,
    'add1': add1,
    'add2': add2,
    'city': city,
    'state': state,
    'pin': pin,
    'aadhar': aadhar,
    'gender': gender,
    'pan': pan,
    'age': age,
    'homeType': homeType,
    'isVerified': isVerified ? 1 : 0,
    'verificationDateTime': verificationDateTime,
    'syncStatus': 'synced',
  };

  factory EmployeeModel.fromDb(Map<String, dynamic> map) => EmployeeModel(
    employeeId: map['employeeId'],
    empCode: map['empCode'] ?? '',
    empName: map['empName'] ?? '',
    mobileNo: map['mobileNo'],
    altMobileNo: map['altMobileNo'],
    emailOfficial: map['emailOfficial'],
    emailPersonal: map['emailPersonal'],
    add1: map['add1'],
    add2: map['add2'],
    city: map['city'],
    state: map['state'],
    pin: map['pin'],
    aadhar: map['aadhar'],
    gender: map['gender'],
    pan: map['pan'],
    age: map['age'],
    homeType: map['homeType'],
    spouseName: map['spouseName'],
    fatherName: map['fatherName'],
    status: map['status'],
    verifiedDate: map['verificationDateTime'],
  );
}
