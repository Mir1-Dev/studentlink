import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:studentlink/models/task.dart';
import 'package:studentlink/services/database_service.dart';

void main() {
  final DatabaseService databaseService = DatabaseService.instance;

  setUpAll(() async {
    // Allows SQLite tests to run on the computer.
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    await databaseService.closeDatabase();

    final String folder = await getDatabasesPath();
    final String path = p.join(folder, 'studentlink.db');

    await deleteDatabase(path);
  });

  tearDownAll(() async {
    await databaseService.closeDatabase();

    final String folder = await getDatabasesPath();
    final String path = p.join(folder, 'studentlink.db');

    await deleteDatabase(path);
  });

  group('DatabaseService CRUD tests', () {
    int? insertedTaskId;

    test('Seeded study locations are available', () async {
      final locations = await databaseService.getStudyLocations();

      expect(locations, isNotEmpty);
      expect(locations.length, 3);
    });

    test('Task can be inserted', () async {
      final Task task = Task(
        title: 'Complete database tests',
        subject: 'Flutter',
        dueDate: DateTime(2026, 8, 16, 18),
      );

      insertedTaskId = await databaseService.insertTask(task);

      expect(insertedTaskId, greaterThan(0));
    });

    test('Inserted task can be retrieved', () async {
      final Task? task =
          await databaseService.getTaskById(insertedTaskId!);

      expect(task, isNotNull);
      expect(task!.title, 'Complete database tests');
      expect(task.subject, 'Flutter');
      expect(task.isCompleted, false);
    });

    test('Task can be updated', () async {
      final Task? originalTask =
          await databaseService.getTaskById(insertedTaskId!);

      final Task updatedTask = originalTask!.copyWith(
        title: 'Database tests completed',
      );

      final int changedRows =
          await databaseService.updateTask(updatedTask);

      final Task? savedTask =
          await databaseService.getTaskById(insertedTaskId!);

      expect(changedRows, 1);
      expect(savedTask!.title, 'Database tests completed');
    });

    test('Task can be marked completed', () async {
      final int changedRows =
          await databaseService.updateTaskCompletion(
        insertedTaskId!,
        true,
      );

      final Task? task =
          await databaseService.getTaskById(insertedTaskId!);

      expect(changedRows, 1);
      expect(task!.isCompleted, true);
    });

    test('Task counts are correct', () async {
      final int total = await databaseService.getTaskCount();
      final int completed =
          await databaseService.getCompletedTaskCount();

      expect(total, 1);
      expect(completed, 1);
    });

    test('Task can be deleted', () async {
      final int deletedRows =
          await databaseService.deleteTask(insertedTaskId!);

      final Task? deletedTask =
          await databaseService.getTaskById(insertedTaskId!);

      expect(deletedRows, 1);
      expect(deletedTask, isNull);
    });
  });
}