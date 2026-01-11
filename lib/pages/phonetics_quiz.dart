import 'package:flutter/material.dart';
import '../components/question_loader.dart';
import '../components/question_template.dart';

class PhoneticsQuiz extends StatefulWidget {
  const PhoneticsQuiz({super.key});

  @override
  State<PhoneticsQuiz> createState() => _PhoneticsQuizState();
}

class _PhoneticsQuizState extends State<PhoneticsQuiz> {

  List<Question> questions = [];
  int currentIndex = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadQuestions().then((q) {
      q.shuffle(); // randomizes order every time
      setState(() {
        questions = q;
        loading = false;
      });
    });
  }

  void handleAnswer(int selectedIndex) {
    final question = questions[currentIndex];

    if (selectedIndex == question.correctIndex) {
      // Correct → move on
      goToNextQuestion();
    } else {
      // Wrong → show alert
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Incorrect"),
          content: const Text("Try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close the alert
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void goToNextQuestion() {
    setState(() {
      if (currentIndex < questions.length - 1) {
        currentIndex++;
      } else {
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            title: Text("Quiz complete"),
            content: Text("You got it right! You have now reached the end of the quiz."),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Phonetics Quiz")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Question ${currentIndex + 1}/${questions.length}",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            Text(
              question.prompt,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            ...List.generate(question.options.length, (i) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => handleAnswer(i),
                  child: Text(question.options[i]),
                ),
              );
            }),
          ],
        ),
      )


    );
  }
}

