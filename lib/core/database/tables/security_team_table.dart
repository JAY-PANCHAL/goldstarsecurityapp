class SecurityTeamTable {
  static const String tableName = 'security_team';

  static const String create =
      '''
CREATE TABLE $tableName (
  code TEXT PRIMARY KEY,
  name TEXT,
  mobile TEXT,
  role TEXT,
  status TEXT DEFAULT 'Active',
  syncStatus TEXT DEFAULT 'local'
);''';
}
