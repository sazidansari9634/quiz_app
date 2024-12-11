import 'package:flutter/material.dart';
import 'package:quiz_app/screens/quiz_splashscrren.dart';
import 'package:quiz_app/themes/app_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      debugShowCheckedModeBanner: false,
      home:  const QuizSplashScreen(),
    );
  }
}
