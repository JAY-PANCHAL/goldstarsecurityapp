class RoundoffScheduleTable {
  static const String tableName = 'roundoff_schedule';

  static const String create =
      '''
CREATE TABLE $tableName (
  code TEXT PRIMARY KEY,
  sgCode TEXT,
  rDate TEXT,
  rTime TEXT,
  buildingCode TEXT,
  buildingName TEXT,
  floorCode TEXT,
  floorName TEXT,
  checkPointCount INTEGER,
  status TEXT DEFAULT 'Pending',
  startDateTime TEXT,
  endDateTime TEXT,
  scannedCPCount INTEGER DEFAULT 0,
  remarks TEXT,
  syncStatus TEXT DEFAULT 'local'
);''';
}
