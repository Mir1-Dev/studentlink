import 'package:flutter/material.dart';

import '../models/task.dart';

/// Reusable preview for one upcoming academic task.
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final Task task;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        minVerticalPadding: 14,
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .16),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 21),
        ),
        title: Text(
          task.title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF17233F),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${task.subject}  •  ${task.dueLabel}',
            style: const TextStyle(color: Color(0xFF7B879E), fontSize: 12),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFFA6B1C5),
        ),
        onTap: onTap,
      ),
    );
  }
}
