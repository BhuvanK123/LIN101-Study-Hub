import 'package:flutter/services.dart' show rootBundle;
import 'question_template.dart';

Future<List<Question>> loadQuestions() async {
  final raw = await rootBundle.loadString('assets/questions.txt');

  final blocks = raw.trim().split('\n\n');

  return blocks.map((block) {
    final lines = block.split('\n');

    final prompt = lines[0].trim();
    final options = lines[1].split('|').map((s) => s.trim()).toList();
    final correctIndex = int.parse(lines[2].trim());

    return Question(
      prompt: prompt,
      options: options,
      correctIndex: correctIndex,
    );
  }).toList();
}