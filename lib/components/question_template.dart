class Question {
  final String prompt;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });
}