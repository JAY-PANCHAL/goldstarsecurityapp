class VerificationsTable {
  static const String tableName = 'verifications';

  static const String create =
      '''
CREATE TABLE $tableName (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  employeeId INTEGER,
  status TEXT,
  rejectionReason TEXT,
  pdfPath TEXT,
  createdAt TEXT,
  syncStatus TEXT DEFAULT 'pending'
);''';
}
