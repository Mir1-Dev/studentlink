import 'package:flutter/material.dart';

import '../../widgets/bottom_nav.dart';

/// Introduces Student Link and opens the main application shell.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Image.asset(
                'assets/images/logo.png',
                width: 285,
                semanticLabel: 'Student Link',
              ),
              const SizedBox(height: 16),
              Text(
                'Your smart campus study companion',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF7B879E),
                ),
              ),
              const SizedBox(height: 38),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => const StudentLinkShell(),
                    ),
                  );
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const Spacer(flex: 4),
              Text(
                'STUDENT LINK',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFFA0ABC0),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
