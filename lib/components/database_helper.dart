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
    try {
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
    } catch (e) {
      // 에러 처리
      throw Exception('Database initialization failed: $e');
    }
  }

  // 메모 추가 함수
  Future<void> insertMemo(String date, String memo) async {
    final db = await database;
    try {
      await db.insert(
        'memos',
        {'date': date, 'memo': memo},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // 에러 처리
      throw Exception('Insert memo failed: $e');
    }
  }

  // 메모 업데이트 함수
  Future<void> updateMemo(String date, String memo) async {
    final db = await database;
    try {
      await db.update(
        'memos',
        {'memo': memo},
        where: 'date = ?',
        whereArgs: [date],
      );
    } catch (e) {
      // 에러 처리
      throw Exception('Update memo failed: $e');
    }
  }

  // 특정 날짜의 메모 가져오기 함수
  Future<String?> getMemo(String date) async {
    final db = await database;
    try {
      List<Map<String, dynamic>> maps = await db.query(
        'memos',
        where: 'date = ?',
        whereArgs: [date],
      );
      if (maps.isNotEmpty) {
        return maps.first['memo'] as String?;
      }
      return null;
    } catch (e) {
      // 에러 처리
      throw Exception('Get memo failed: $e');
    }
  }

  // 데이터베이스 연결 닫기
  Future<void> close() async {
    final db = await database;
    try {
      await db.close();
    } catch (e) {
      // 에러 처리
      throw Exception('Close database failed: $e');
    }
  }
}
