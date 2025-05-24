// lib/data/database/database_helper.dart
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
    
    // Insert initial data without status column
    await db.insert('tasks', {
      'id': '1',
      'title': 'Kecerdasan Buatan',
      'description': 'Monitoring Button',
      'date': '23 May 2022', 
      'time': '12:00',
      'isDone': 1, // This will show as 'Selesai'
    });
      
    await db.insert('tasks', {
      'id': '2',
      'title': 'Workshop Permrograman Framework',
      'description': 'Monitoring Button',
      'date': '2 April 2022', 
      'time': '12:00',
      'isDone': 0, // This will show as 'Terlambat' (past date)
    });
      
    await db.insert('tasks', {
      'id': '3',
      'title': 'Workshop Mobile Programming',
      'description': 'Monitoring Button',
      'date': '15 December 2025', 
      'time': '12:00',
      'isDone': 0, // This will show as 'Belum Selesai' (future date)
    });
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Remove status column if upgrading from version 1
      await db.execute('DROP TABLE IF EXISTS tasks');
      await _createDb(db, newVersion);
    }
  }

  // CRUD Operations

  // Create: Insert a new task
  Future<int> insertTask(TaskModel task) async {
    final db = await database;
    return await db.insert(
      'tasks',
      {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'date': task.date,
        'time': task.time,
        'isDone': task.isDone ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read: Get all tasks
  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    
    return List.generate(maps.length, (i) {
      return TaskModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        date: maps[i]['date'],
        time: maps[i]['time'],
        isDone: maps[i]['isDone'] == 1,
      );
    });
  }

  // Read: Get tasks by filter
  Future<List<TaskModel>> getTasksByFilter(String filter) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    
    // Convert to TaskModel list first to get calculated status
    final allTasks = List.generate(maps.length, (i) {
      return TaskModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        date: maps[i]['date'],
        time: maps[i]['time'],
        isDone: maps[i]['isDone'] == 1,
      );
    });
    
    // Filter based on calculated status
    if (filter == 'Semua') {
      return allTasks;
    } else if (filter == 'Terlambat') {
      return allTasks.where((task) => task.status == 'Terlambat').toList();
    } else if (filter == 'Belum Selesai') {
      return allTasks.where((task) => task.status == 'Belum Selesai').toList();
    } else if (filter == 'Selesai') {
      return allTasks.where((task) => task.status == 'Selesai').toList();
    } else {
      return allTasks;
    }
  }

  // Update: Update a task
  Future<int> updateTask(TaskModel task) async {
    final db = await database;
    return await db.update(
      'tasks',
      {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'date': task.date,
        'time': task.time,
        'isDone': task.isDone ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Update: Toggle task completion
  Future<int> toggleTaskCompletion(String id, bool isDone) async {
    final db = await database;
    return await db.update(
      'tasks',
      {'isDone': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete: Delete a task
  Future<int> deleteTask(String id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}