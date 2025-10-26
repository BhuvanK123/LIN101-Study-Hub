import 'package:flutter/material.dart';

class PhoneticsPage extends StatelessWidget {
  const PhoneticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phonetics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose one of the options below to get started:', style: Theme.of(context).textTheme.bodyLarge),

            SizedBox(height: 20),

            // Flashcards button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/p_flashcards');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
              ),
              child: Text('Flashcards'),
            ),

            SizedBox(height: 10),

            // Quiz Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/p_quiz');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
              ),
              child: Text('Quiz'),
            ),

          ],
        ),
      )
    );
  }
}