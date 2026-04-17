class RoundoffCheckpointsTable {
  static const String tableName = 'roundoff_checkpoints';

  static const String create =
      '''
CREATE TABLE $tableName (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  roundoffCode TEXT,
  cpCode TEXT,
  cpScanDateTime TEXT,
  status TEXT DEFAULT 'Pending',
  FOREIGN KEY (roundoffCode) REFERENCES roundoff_schedule(code)
);''';
}
