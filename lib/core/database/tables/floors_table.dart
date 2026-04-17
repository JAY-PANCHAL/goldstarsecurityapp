class FloorsTable {
  static const String tableName = 'floors';

  static const String create =
      '''
CREATE TABLE $tableName (
  code TEXT PRIMARY KEY,
  buildingCode TEXT,
  name TEXT,
  status TEXT DEFAULT 'Active',
  syncStatus TEXT DEFAULT 'local'
);''';
}
