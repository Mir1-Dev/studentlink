import 'package:flutter/material.dart';

import '../models/task.dart';
import 'database_service.dart';

class TaskRepository {
  TaskRepository._internal();
  static final TaskRepository instance = TaskRepository._internal();

  final ValueNotifier<List<Task>> tasksNotifier = ValueNotifier<List<Task>>([]);

  List<Task> get tasks => tasksNotifier.value;

  Future<List<Task>> loadTasks() async {
    final tasks = await DatabaseService.instance.getTasks();
    tasksNotifier.value = tasks;
    return tasks;
  }

  Future<List<Task>> resetForTest() async {
    await DatabaseService.instance.deleteDatabase();
    await DatabaseService.instance.database;
    return loadTasks();
  }

  Future<void> addTask(Task task) async {
    final newId = await DatabaseService.instance.insertTask(task);
    final savedTask = task.copyWith(id: newId);
    tasksNotifier.value = [...tasksNotifier.value, savedTask];
  }

  Future<void> updateTask(Task task) async {
    final rowsChanged = await DatabaseService.instance.updateTask(task);
    if (rowsChanged == 0) {
      return;
    }

    tasksNotifier.value = tasksNotifier.value
        .map((item) => item.id == task.id ? task : item)
        .toList();
  }

  Future<void> deleteTask(Task task) async {
    if (task.id == null) {
      return;
    }

    final rowsChanged = await DatabaseService.instance.deleteTask(task.id!);
    if (rowsChanged == 0) {
      return;
    }

    tasksNotifier.value = tasksNotifier.value
        .where((item) => item.id != task.id)
        .toList();
  }

  Future<void> toggleDone(Task task) async {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updated);
  }

  void refresh() {
    tasksNotifier.value = List.from(tasksNotifier.value);
  }
}