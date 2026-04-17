class CheckpointsTable {
  static const String tableName = 'checkpoints';

  static const String create =
      '''
CREATE TABLE $tableName (
  code TEXT PRIMARY KEY,
  floorCode TEXT,
  name TEXT,
  qrCode TEXT,
  status TEXT DEFAULT 'Active',
  syncStatus TEXT DEFAULT 'local'
);''';
}
