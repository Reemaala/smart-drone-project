import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    String path = join(await getDatabasesPath(), 'users.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('CREATE TABLE users(id INTEGER PRIMARY KEY, email TEXT)');
      },
    );
    return _database!;
  }

  static Future<void> insertEmail(String email) async {
    final db = await getDatabase();
    await db.insert('users', {'email': email}, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<List<String>> getAllEmails() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => maps[i]['email'] as String);
  }
}
