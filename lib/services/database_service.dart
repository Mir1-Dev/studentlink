import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/study_location.dart';
import '../models/task.dart';

class DatabaseService {
  DatabaseService._internal();
  static final DatabaseService instance = DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final file = join(dbPath, 'studentlink.db');
    await databaseFactory.deleteDatabase(file);
    _database = null;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'studentlink.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            subject TEXT NOT NULL,
            due_date INTEGER NOT NULL,
            is_completed INTEGER NOT NULL DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE study_locations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            campus TEXT NOT NULL,
            type TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            is_quiet INTEGER NOT NULL DEFAULT 0
          )
        ''');

        final seedLocations = [
          StudyLocation(
            name: 'Main Library',
            campus: 'North Campus',
            type: 'Library',
            latitude: 40.7128,
            longitude: -74.0060,
            isQuiet: true,
          ),
          StudyLocation(
            name: 'Science Hall',
            campus: 'Central Campus',
            type: 'Study Room',
            latitude: 40.7138,
            longitude: -74.0050,
            isQuiet: false,
          ),
          StudyLocation(
            name: 'Quiet Courtyard',
            campus: 'South Campus',
            type: 'Outdoor',
            latitude: 40.7118,
            longitude: -74.0070,
            isQuiet: true,
          ),
        ];

        for (final location in seedLocations) {
          await db.insert('study_locations', location.toMap());
        }

        final seedTasks = [
          Task(
            title: 'Chapter 5 Reading',
            subject: 'Biology',
            dueDate: DateTime.now(),
            isCompleted: false,
          ),
          Task(
            title: 'Math Problem Set',
            subject: 'Calculus',
            dueDate: DateTime.now().add(const Duration(days: 1)),
            isCompleted: false,
          ),
          Task(
            title: 'Essay Draft',
            subject: 'English Lit',
            dueDate: DateTime.now().add(const Duration(days: 2)),
            isCompleted: false,
          ),
          Task(
            title: 'Lab Report',
            subject: 'Chemistry',
            dueDate: DateTime.now().add(const Duration(days: 3)),
            isCompleted: false,
          ),
          Task(
            title: 'Vocab Quiz Review',
            subject: 'Spanish',
            dueDate: DateTime.now().add(const Duration(days: 1)),
            isCompleted: true,
          ),
        ];

        for (final task in seedTasks) {
          await db.insert('tasks', task.toMap());
        }
      },
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final rows = await db.query(
      'tasks',
      orderBy: 'due_date ASC',
    );
    return rows.map(Task.fromMap).toList();
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return db.insert('tasks', task.toMap());
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<StudyLocation>> getStudyLocations() async {
    final db = await database;
    final rows = await db.query('study_locations');
    return rows.map(StudyLocation.fromMap).toList();
  }
}
