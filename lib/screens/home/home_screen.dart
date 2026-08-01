import 'package:flutter/material.dart';

import '../../widgets/progress_card.dart';
import '../../widgets/task_card.dart';

/// Displays a quick summary of today's study tasks and progress.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
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
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF7B879E)),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Alex Johnson',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              const SizedBox(width: 4),
              const Icon(
                Icons.waving_hand_rounded,
                color: Color(0xFFFFB44A),
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ProgressCard(completed: 2, total: 5),
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
          const TaskCard(
            title: 'Chapter 5 Reading',
            subject: 'Biology',
            schedule: 'Today, 4 PM',
            color: Color(0xFF62A7E8),
            icon: Icons.menu_book_rounded,
          ),
          const TaskCard(
            title: 'Math Problem Set',
            subject: 'Calculus',
            schedule: 'Tomorrow, 9 AM',
            color: Color(0xFF62B99A),
            icon: Icons.calculate_rounded,
          ),
          const TaskCard(
            title: 'Essay Draft',
            subject: 'English Lit',
            schedule: 'Thu, 11:59 PM',
            color: Color(0xFF8D78D8),
            icon: Icons.edit_note_rounded,
          ),
        ],
      ),
    );
  }
}
