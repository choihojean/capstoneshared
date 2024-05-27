import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'memos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE memos(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, memo TEXT)', // 스키마 확인
        );
      },
    );
  }

  Future<void> insertMemo(String date, String memo) async {
    final db = await database;
    await db.insert(
      'memos',
      {'date': date, 'memo': memo},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getMemo(String date) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'memos',
      where: 'date = ?',
      whereArgs: [date],
    );
    if (maps.isNotEmpty) {
      return maps.first['memo'];
    }
    return null;
  }
}
