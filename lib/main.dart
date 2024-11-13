import 'package:flutter/material.dart';
import 'package:quiz_app/screens/quiz_splashscrren.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      home:  QuizSplashScreen(),
    );
  }
}