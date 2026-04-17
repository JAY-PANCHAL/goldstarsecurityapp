class BuildingsTable {
  static const String tableName = 'buildings';

  static const String create =
      '''
CREATE TABLE $tableName (
  code TEXT PRIMARY KEY,
  name TEXT,
  address TEXT,
  status TEXT DEFAULT 'Active',
  syncStatus TEXT DEFAULT 'local'
);''';
}
