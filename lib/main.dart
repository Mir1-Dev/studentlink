import 'package:flutter/material.dart';

import 'screens/splash/splash_screen.dart';

/// Starts the Student Link Flutter application.
void main() => runApp(const StudentLinkApp());

/// Defines the shared theme and first screen for the application.
class StudentLinkApp extends StatelessWidget {
  const StudentLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4E73C8);
    return MaterialApp(
      title: 'Student Link',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F7FD),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F7FD),
          foregroundColor: Color(0xFF17233F),
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE4EAF5)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
