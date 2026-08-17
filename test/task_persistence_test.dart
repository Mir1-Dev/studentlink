import 'package:flutter_test/flutter_test.dart';
import 'package:studentlink/models/task.dart';
import 'package:studentlink/services/database_service.dart';
import 'package:studentlink/services/task_repository.dart';

void main() {
  setUp(() async {
    await DatabaseService.instance.deleteDatabase();
    await TaskRepository.instance.resetForTest();
  });

  test('Task can be serialized and deserialized', () {
    final dueDate = DateTime(2026, 8, 20, 16, 30);
    final task = Task(
      id: 1,
      title: 'Biology Quiz',
      subject: 'Biology',
      dueDate: dueDate,
      isCompleted: false,
    );

    final map = task.toMap();
    final recreated = Task.fromMap(map);

    expect(map['title'], 'Biology Quiz');
    expect(recreated.id, 1);
    expect(recreated.title, 'Biology Quiz');
    expect(recreated.subject, 'Biology');
    expect(recreated.isCompleted, isFalse);
    expect(recreated.dueLabel, contains('Aug'));
  });

  test('DatabaseService stores and reads tasks', () async {
    final dueDate = DateTime(2026, 8, 18);
    final task = Task(
      title: 'Math Homework',
      subject: 'Mathematics',
      dueDate: dueDate,
      isCompleted: false,
    );

    final db = await DatabaseService.instance.database;
    final id = await db.insert('tasks', task.toMap());
    final rows = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    expect(rows.length, 1);
    expect(rows.first['title'], 'Math Homework');
    expect(rows.first['subject'], 'Mathematics');
  });

  test('TaskRepository can load seeded tasks', () async {
    final tasks = await TaskRepository.instance.loadTasks();

    expect(tasks, isNotEmpty);
    expect(
      tasks.any(
        (task) =>
            task.title.contains('Reading') || task.subject.contains('Biology'),
      ),
      isTrue,
    );
  });
}
