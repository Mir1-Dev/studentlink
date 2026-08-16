import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/study_location.dart';
import '../models/task.dart';

class DatabaseService {
  DatabaseService._privateConstructor();

  static final DatabaseService instance =
      DatabaseService._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final String databaseFolder = await getDatabasesPath();
    final String databasePath = p.join(
      databaseFolder,
      'studentlink.db',
    );

    return openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(
    Database database,
    int version,
  ) async {
    await database.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        subject TEXT NOT NULL,
        due_date TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await database.execute('''
      CREATE TABLE study_locations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        description TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL
      )
    ''');

    await _seedStudyLocations(database);
  }

  Future<void> _seedStudyLocations(
    Database database,
  ) async {
    final List<StudyLocation> locations = [
      const StudyLocation(
        name: 'Conestoga College Waterloo Campus',
        address: '108 University Avenue East, Waterloo, Ontario',
        description: 'A campus study location for StudentLink users.',
        latitude: 43.4796,
        longitude: -80.5170,
      ),
      const StudyLocation(
        name: 'Waterloo Public Library',
        address: '35 Albert Street, Waterloo, Ontario',
        description: 'A quiet public library with study spaces.',
        latitude: 43.4667,
        longitude: -80.5248,
      ),
      const StudyLocation(
        name: 'Kitchener Public Library',
        address: '85 Queen Street North, Kitchener, Ontario',
        description:
            'A public library suitable for individual and group study.',
        latitude: 43.4519,
        longitude: -80.4862,
      ),
    ];

    final Batch batch = database.batch();

    for (final StudyLocation location in locations) {
      final Map<String, dynamic> values = location.toMap();
      values.remove('id');

      batch.insert(
        'study_locations',
        values,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<int> insertTask(Task task) async {
    final Database db = await database;
    final Map<String, dynamic> values = task.toMap();

    values.remove('id');

    return db.insert(
      'tasks',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getTasks() async {
    final Database db = await database;

    final List<Map<String, dynamic>> result =
        await db.query(
      'tasks',
      orderBy: 'due_date ASC',
    );

    return result
        .map((Map<String, dynamic> map) => Task.fromMap(map))
        .toList();
  }

  Future<Task?> getTaskById(int id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> result =
        await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return Task.fromMap(result.first);
  }

  Future<int> updateTask(Task task) async {
    if (task.id == null) {
      throw ArgumentError(
        'A task must have an ID before it can be updated.',
      );
    }

    final Database db = await database;

    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> updateTaskCompletion(
    int id,
    bool isCompleted,
  ) async {
    final Database db = await database;

    return db.update(
      'tasks',
      {
        'is_completed': isCompleted ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(int id) async {
    final Database db = await database;

    return db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<StudyLocation>>
      getStudyLocations() async {
    final Database db = await database;

    final List<Map<String, dynamic>> result =
        await db.query(
      'study_locations',
      orderBy: 'name ASC',
    );

    return result
        .map(
          (Map<String, dynamic> map) =>
              StudyLocation.fromMap(map),
        )
        .toList();
  }

  Future<int> getTaskCount() async {
    final Database db = await database;

    final List<Map<String, dynamic>> result =
        await db.rawQuery(
      'SELECT COUNT(*) AS count FROM tasks',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getCompletedTaskCount() async {
    final Database db = await database;

    final List<Map<String, dynamic>> result =
        await db.rawQuery(
      '''
      SELECT COUNT(*) AS count
      FROM tasks
      WHERE is_completed = 1
      ''',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}