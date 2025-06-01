import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timelyu/data/models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'timelyu_tasks.db');
    return await openDatabase(
      path,
      version: 2, // Increment version for schema change
      onCreate: _createDb,
      onUpgrade: _upgradeDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        isDone INTEGER NOT NULL
      )
    ''');

    // Mencoba inisial data
    await db.insert('tasks', {
      'id': '1',
      'title': 'Kecerdasan Buatan',
      'description': 'Monitoring Button',
      'date': '23 May 2022',
      'time': '12:00',
      'isDone': 1, // Selesai
    });

    await db.insert('tasks', {
      'id': '2',
      'title': 'Workshop Permrograman Framework',
      'description': 'Monitoring Button',
      'date': '2 April 2022',
      'time': '12:00',
      'isDone': 0, // Terlambat (past date)
    });

    await db.insert('tasks', {
      'id': '3',
      'title': 'Workshop Mobile Programming',
      'description': 'Monitoring Button',
      'date': '15 December 2025',
      'time': '12:00',
      'isDone': 0, // Belum Selesai (future date)
    });
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Simple upgrade: drop and recreate. For production, use ALTER TABLE.
      await db.execute('DROP TABLE IF EXISTS tasks');
      await _createDb(db, newVersion);
    }
  }

  // Create: Menambahkan task baru
  Future<int> insertTask(TaskModel task) async {
    final db = await database;
    return await db.insert(
      'tasks',
      task.toJson(), // Using toJson for consistency
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read: Membaca semua tasks
  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return TaskModel.fromJson(maps[i]);
    });
  }

  // Read: Membaca tasks berdasarkan filter
  Future<List<TaskModel>> getTasksByFilter(String filter) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    final allTasks = List.generate(maps.length, (i) {
      return TaskModel.fromJson(maps[i]);
    });

    if (filter == 'Semua') {
      return allTasks;
    } else {
      return allTasks.where((task) => task.status == filter).toList();
    }
  }

  // Update: Update task terbaru
  Future<int> updateTask(TaskModel task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toJson(), // Using toJson for consistency
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Update: tombol ketika task selesai
  Future<int> toggleTaskCompletion(String id, bool isDone) async {
    final db = await database;
    return await db.update(
      'tasks',
      {'isDone': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete: Menghapus task
  Future<int> deleteTask(String id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}