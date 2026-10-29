import 'package:flutter/material.dart';
import 'core/app_colors.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/note_detail_screen.dart';
import 'screens/note_form_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const FNotesApp());
}

class FNotesApp extends StatelessWidget {
  const FNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FNotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.background,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/new-note': (context) => const NoteFormScreen(),
        '/detail-note': (context) => const NoteDetailScreen(),
      },
    );
  }
}
