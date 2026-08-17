import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../../services/task_repository.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/progress_card.dart';
import '../../widgets/task_card.dart';
import '../task_detail/task_detail_screen.dart';

/// Displays a quick summary of today's study tasks and progress.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder<List<Task>>(
        valueListenable: TaskRepository.instance.tasksNotifier,
        builder: (context, tasks, _) {
          final visibleTasks = tasks.take(3).toList();
          final completedCount = tasks.where((task) => task.isCompleted).length;
          final totalCount = tasks.length;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            children: [
              const AppLogo(size: 32),
              const SizedBox(height: 18),
              Text(
                'Good morning,',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF7B879E)),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Student',
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
              ProgressCard(completed: completedCount, total: totalCount == 0 ? 1 : totalCount),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming tasks',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  TextButton(onPressed: () {}, child: const Text('See all')),
                ],
              ),
              const SizedBox(height: 4),
              if (visibleTasks.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('No tasks yet. Add one from the Add tab.'),
                )
              else
                ...visibleTasks.map((task) {
                  final color = _taskColor(task.subject);
                  final icon = _taskIcon(task.subject);

                  return TaskCard(
                    task: task,
                    color: color,
                    icon: icon,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TaskDetailScreen(task: task),
                        ),
                      );
                    },
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  Color _taskColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'biology':
        return const Color(0xFF62A7E8);
      case 'calculus':
        return const Color(0xFF62B99A);
      case 'english lit':
        return const Color(0xFF8D78D8);
      case 'chemistry':
        return const Color(0xFFEF8D54);
      default:
        return const Color(0xFF4E73C8);
    }
  }

  IconData _taskIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'biology':
        return Icons.menu_book_rounded;
      case 'calculus':
        return Icons.calculate_rounded;
      case 'english lit':
        return Icons.edit_note_rounded;
      case 'chemistry':
        return Icons.science_rounded;
      default:
        return Icons.checklist_rounded;
    }
  }
}
