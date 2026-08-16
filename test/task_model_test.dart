import 'package:flutter_test/flutter_test.dart';
import 'package:studentlink/models/task.dart';

void main() {
  group('Task model tests', () {
    test('Task converts to a database map', () {
      final Task task = Task(
        id: 1,
        title: 'Complete Flutter project',
        subject: 'Mobile Programming',
        dueDate: DateTime(2026, 8, 16, 17, 30),
        isCompleted: true,
      );

      final Map<String, dynamic> map = task.toMap();

      expect(map['id'], 1);
      expect(map['title'], 'Complete Flutter project');
      expect(map['subject'], 'Mobile Programming');
      expect(map['due_date'], '2026-08-16T17:30:00.000');
      expect(map['is_completed'], 1);
    });

    test('Task is created from a database map', () {
      final Map<String, dynamic> map = {
        'id': 2,
        'title': 'Study chapter five',
        'subject': 'Biology',
        'due_date': '2026-08-17T16:00:00.000',
        'is_completed': 0,
      };

      final Task task = Task.fromMap(map);

      expect(task.id, 2);
      expect(task.title, 'Study chapter five');
      expect(task.subject, 'Biology');
      expect(task.dueDate, DateTime(2026, 8, 17, 16));
      expect(task.isCompleted, false);
    });

    test('copyWith creates an updated task', () {
      final Task originalTask = Task(
        id: 3,
        title: 'Write report',
        subject: 'English',
        dueDate: DateTime(2026, 8, 18),
      );

      final Task updatedTask = originalTask.copyWith(
        title: 'Finish report',
        isCompleted: true,
      );

      expect(updatedTask.id, 3);
      expect(updatedTask.title, 'Finish report');
      expect(updatedTask.subject, 'English');
      expect(updatedTask.isCompleted, true);
    });
  });
}