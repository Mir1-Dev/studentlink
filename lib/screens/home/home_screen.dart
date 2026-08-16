import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../../services/database_service.dart';
import '../../widgets/progress_card.dart';
import '../../widgets/task_card.dart';

/// Displays task progress and upcoming tasks stored in SQLite.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;

  List<Task> _tasks = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  /// Reads the current task list from SQLite.
  Future<void> _loadTasks() async {
    try {
      final List<Task> tasks = await _databaseService.getTasks();

      if (!mounted) return;

      setState(() {
        _tasks = tasks;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'The tasks could not be loaded.';
      });
    }
  }

  /// Changes a task between completed and pending.
  Future<void> _toggleTask(Task task) async {
    if (task.id == null) return;

    await _databaseService.updateTaskCompletion(
      task.id!,
      !task.isCompleted,
    );

    await _loadTasks();
  }

  /// Deletes a task from SQLite.
  Future<void> _deleteTask(Task task) async {
    if (task.id == null) return;

    await _databaseService.deleteTask(task.id!);
    await _loadTasks();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${task.title} was deleted.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int completedTasks =
        _tasks.where((Task task) => task.isCompleted).length;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadTasks,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          children: [
            Image.asset(
              'assets/images/logo1.png',
              width: 72,
              alignment: Alignment.centerLeft,
            ),
            const SizedBox(height: 18),
            Text(
              'Good morning,',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF7B879E),
                  ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Welcome back!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.waving_hand_rounded,
                  color: Color(0xFFFFB44A),
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // The progress values now come from SQLite.
            ProgressCard(
              completed: completedTasks,
              total: _tasks.length,
            ),

            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming tasks',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                TextButton(
                  onPressed: _loadTasks,
                  child: const Text('Refresh'),
                ),
              ],
            ),
            const SizedBox(height: 4),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _loadTasks,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              )
            else if (_tasks.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 42,
                        color: Color(0xFF7B879E),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No tasks have been added yet.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._tasks.map(
                (Task task) => Dismissible(
                  key: ValueKey<int>(task.id!),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (_) {
                    _deleteTask(task);
                  },
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      _toggleTask(task);
                    },
                    child: Opacity(
                      opacity: task.isCompleted ? 0.55 : 1,
                      child: TaskCard(
                        title: task.title,
                        subject: task.isCompleted
                            ? '${task.subject} • Completed'
                            : task.subject,
                        schedule: _formatDueDate(task.dueDate),
                        color: _getSubjectColor(task.subject),
                        icon: task.isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.assignment_rounded,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDueDate(DateTime date) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime taskDay = DateTime(date.year, date.month, date.day);

    String dayText;

    if (taskDay == today) {
      dayText = 'Today';
    } else if (taskDay == today.add(const Duration(days: 1))) {
      dayText = 'Tomorrow';
    } else {
      dayText = '${date.month}/${date.day}/${date.year}';
    }

    final int hour =
        date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final String minute = date.minute.toString().padLeft(2, '0');
    final String period = date.hour >= 12 ? 'PM' : 'AM';

    return '$dayText, $hour:$minute $period';
  }

  Color _getSubjectColor(String subject) {
    final List<Color> colors = [
      const Color(0xFF62A7E8),
      const Color(0xFF62B99A),
      const Color(0xFF8D78D8),
      const Color(0xFFE89A62),
    ];

    return colors[subject.hashCode.abs() % colors.length];
  }
}