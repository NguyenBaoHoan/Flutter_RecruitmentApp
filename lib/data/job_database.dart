import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/job_model.dart';

class JobDatabase {
  static final JobDatabase instance = JobDatabase._init();
  static Database? _database;

  JobDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('jobs.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE jobs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        iconUrl TEXT,
        title TEXT,
        company TEXT,
        salary TEXT,
        location TEXT,
        postDate TEXT,
        status TEXT,
        description TEXT
      )
    ''');
  }

  Future<int> createJob(Job job) async {
    final db = await instance.database;
    return await db.insert('jobs', job.toMap());
  }

  Future<List<Job>> readAllJobs() async {
    final db = await instance.database;
    final result = await db.query('jobs');
    return result.map((json) => Job.fromMap(json)).toList();
  }

  Future<int> updateJob(Job job, int id) async {
    final db = await instance.database;
    return await db.update('jobs', job.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteJob(int id) async {
    final db = await instance.database;
    return await db.delete('jobs', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
