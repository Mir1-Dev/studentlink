import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../../services/database_service.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;

  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final List<Task> tasks = await _databaseService.getTasks();

    if (!mounted) return;

    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _showTaskForm({Task? existingTask}) async {
    final TextEditingController titleController =
        TextEditingController(text: existingTask?.title ?? '');

    final TextEditingController subjectController =
        TextEditingController(text: existingTask?.subject ?? '');

    DateTime selectedDate =
        existingTask?.dueDate ?? DateTime.now().add(const Duration(days: 1));

    final bool? saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (
            BuildContext context,
            StateSetter setSheetState,
          ) {
            Future<void> chooseDate() async {
              final DateTime? date = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(days: 730),
                ),
              );

              if (date == null || !context.mounted) return;

              final TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(selectedDate),
              );

              setSheetState(() {
                selectedDate = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time?.hour ?? selectedDate.hour,
                  time?.minute ?? selectedDate.minute,
                );
              });
            }

            Future<void> saveTask() async {
              final String title = titleController.text.trim();
              final String subject = subjectController.text.trim();

              if (title.isEmpty || subject.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please enter both a title and subject.',
                    ),
                  ),
                );
                return;
              }

              if (existingTask == null) {
                await _databaseService.insertTask(
                  Task(
                    title: title,
                    subject: subject,
                    dueDate: selectedDate,
                  ),
                );
              } else {
                await _databaseService.updateTask(
                  existingTask.copyWith(
                    title: title,
                    subject: subject,
                    dueDate: selectedDate,
                  ),
                );
              }

              if (context.mounted) {
                Navigator.pop(context, true);
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      existingTask == null ? 'Add Task' : 'Edit Task',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Task title',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        prefixIcon: Icon(Icons.school_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.event),
                      title: const Text('Due date and time'),
                      subtitle: Text(_formatDate(selectedDate)),
                      trailing: const Icon(Icons.edit_calendar),
                      onTap: chooseDate,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: saveTask,
                        icon: const Icon(Icons.save),
                        label: Text(
                          existingTask == null
                              ? 'Save Task'
                              : 'Update Task',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    titleController.dispose();
    subjectController.dispose();

    if (saved == true) {
      await _loadTasks();
    }
  }

  Future<void> _toggleTask(Task task) async {
    if (task.id == null) return;

    await _databaseService.updateTaskCompletion(
      task.id!,
      !task.isCompleted,
    );

    await _loadTasks();
  }

  Future<void> _confirmDelete(Task task) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete task?'),
          content: Text(
            'Are you sure you want to delete "${task.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && task.id != null) {
      await _databaseService.deleteTask(task.id!);
      await _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final int completedCount =
        _tasks.where((Task task) => task.isCompleted).length;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadTasks,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Tasks',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$completedCount of ${_tasks.length} completed',
                      style: const TextStyle(
                        color: Color(0xFF7B879E),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showTaskForm();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_tasks.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.assignment_outlined,
                        size: 50,
                        color: Color(0xFF7B879E),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No tasks yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Add your first study task.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showTaskForm();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Task'),
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._tasks.map(
                (Task task) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) {
                        _toggleTask(task);
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(
                      '${task.subject}\nDue: ${_formatDate(task.dueDate)}',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == 'edit') {
                          _showTaskForm(existingTask: task);
                        } else if (value == 'delete') {
                          _confirmDelete(task);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return const [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 10),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 10),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    final int hour =
        date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final String minute = date.minute.toString().padLeft(2, '0');
    final String period = date.hour >= 12 ? 'PM' : 'AM';

    return '${date.month}/${date.day}/${date.year} '
        '$hour:$minute $period';
  }
}