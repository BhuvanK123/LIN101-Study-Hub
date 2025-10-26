import 'package:flutter/material.dart';
import 'package:lin101_prep/pages/phonetics_flashcards.dart';
import 'package:lin101_prep/pages/phonetics_page.dart';
import 'package:lin101_prep/pages/phonetics_quiz.dart';
import 'homepage.dart';

void main() {
  runApp(const Lin101App());
}

class Lin101App extends StatelessWidget {
  const Lin101App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LIN101 Study Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green[50],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            minimumSize: Size(double.infinity, 60),
            padding: EdgeInsets.symmetric(horizontal: 24),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: HomePage(),
      routes: {
        '/phonetics': (context) => PhoneticsPage(),
        '/p_flashcards': (context) => PhoneticsFlashcards(),
        '/p_quiz': (context) => PhoneticsQuiz(),
        '/morphology': (context) => MorphologyPage(),
      },
    );
  }
}



class MorphologyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Morphology')),
      body: Center(child: Text('Welcome to Morphology!')),
    );
  }
}