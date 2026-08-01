import 'package:flutter/material.dart';

/// Reusable preview for one upcoming academic task.
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.subject,
    required this.schedule,
    required this.color,
    required this.icon,
  });

  final String title;
  final String subject;
  final String schedule;
  final Color color;
  final IconData icon;

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
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF17233F),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '$subject  •  $schedule',
            style: const TextStyle(color: Color(0xFF7B879E), fontSize: 12),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFFA6B1C5),
        ),
        onTap: () {},
      ),
    );
  }
}
