import 'package:flutter/material.dart';

import '../screens/home/home_screen.dart';
import '../screens/tasks/tasks_screen.dart';

/// Keeps the five main sections available through bottom navigation.
class StudentLinkShell extends StatefulWidget {
  const StudentLinkShell({super.key});

  @override
  State<StudentLinkShell> createState() => _StudentLinkShellState();
}

class _StudentLinkShellState extends State<StudentLinkShell> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    HomeScreen(),

    // Real SQLite task list.
    TasksScreen(),

    // The Tasks screen also contains the Add Task button and form.
    TasksScreen(),

    _FeaturePlaceholder(
      icon: Icons.map_outlined,
      title: 'Study Locations',
      message: 'Nearby study locations will appear here.',
    ),

    _FeaturePlaceholder(
      icon: Icons.cloud_outlined,
      title: 'Weather',
      message: 'The campus forecast will appear here.',
    ),
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectPage,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDDE7FF),
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt_rounded),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Add',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.cloud_outlined),
            selectedIcon: Icon(Icons.cloud),
            label: 'Weather',
          ),
        ],
      ),
    );
  }
}

class _FeaturePlaceholder extends StatelessWidget {
  const _FeaturePlaceholder({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF7B879E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}