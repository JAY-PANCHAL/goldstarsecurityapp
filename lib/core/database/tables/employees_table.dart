class EmployeesTable {
  static const String tableName = 'employees';

  static const String create =
      '''
CREATE TABLE $tableName (
  employeeId INTEGER PRIMARY KEY,
  empCode TEXT NOT NULL,
  empName TEXT NOT NULL,
  mobileNo TEXT,
  altMobileNo TEXT,
  emailOfficial TEXT,
  emailPersonal TEXT,
  add1 TEXT,
  add2 TEXT,
  city TEXT,
  state TEXT,
  pin TEXT,
  aadhar TEXT,
  gender TEXT,
  pan TEXT,
  isVerified INTEGER DEFAULT 0,
  verificationDateTime TEXT,
  syncStatus TEXT DEFAULT 'synced'
);''';
}
