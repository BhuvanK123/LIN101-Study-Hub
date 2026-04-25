import 'dart:math';

import 'package:flutter/material.dart';

class SyllablesPage extends StatefulWidget {
  const SyllablesPage({super.key});

  @override
  State<SyllablesPage> createState() => _SyllablesPageState();
}

class _SyllablesPageState extends State<SyllablesPage> {
  final List<SyllableItem> _items = const [
    SyllableItem(
      word: 'banana',
      syllables: ['ba', 'na', 'na'],
      stressedIndex: 1,
    ),
    SyllableItem(
      word: 'computer',
      syllables: ['com', 'pu', 'ter'],
      stressedIndex: 1,
    ),
    SyllableItem(
      word: 'linguistics',
      syllables: ['lin', 'guis', 'tics'],
      stressedIndex: 1,
    ),
    SyllableItem(
      word: 'phonology',
      syllables: ['pho', 'nol', 'o', 'gy'],
      stressedIndex: 1,
    ),
    SyllableItem(
      word: 'analysis',
      syllables: ['a', 'na', 'ly', 'sis'],
      stressedIndex: 2,
    ),
    SyllableItem(
      word: 'syllable',
      syllables: ['syl', 'la', 'ble'],
      stressedIndex: 0,
    ),
    SyllableItem(
      word: 'language',
      syllables: ['lan', 'guage'],
      stressedIndex: 0,
    ),
    SyllableItem(
      word: 'photograph',
      syllables: ['pho', 'to', 'graph'],
      stressedIndex: 0,
    ),
  ];

  final Random _random = Random();
  final TextEditingController _splitController = TextEditingController();

  final Map<int, List<int>> _countChoicesCache = {};

  int _countIndex = 0;
  int _countCorrect = 0;
  bool _countAnswered = false;
  String? _countFeedback;

  int _splitIndex = 0;
  int _splitCorrect = 0;
  String? _splitFeedback;

  int _stressIndex = 0;
  int _stressCorrect = 0;
  int? _selectedStress;
  String? _stressFeedback;

  @override
  void dispose() {
    _splitController.dispose();
    super.dispose();
  }

  List<int> _getCountChoices(int index) {
    return _countChoicesCache.putIfAbsent(index, () {
      final target = _items[index].syllableCount;
      final choices = <int>{target, max(1, target - 1), target + 1};

      while (choices.length < 4) {
        choices.add(1 + _random.nextInt(5));
      }

      final list = choices.toList()..shuffle(_random);
      return list;
    });
  }

  void _checkCountAnswer(int choice) {
    if (_countAnswered) return;

    final target = _items[_countIndex].syllableCount;
    final isCorrect = choice == target;

    setState(() {
      _countAnswered = true;
      if (isCorrect) {
        _countCorrect++;
        _countFeedback =
            'Correct. ${_items[_countIndex].word} has $target syllables.';
      } else {
        _countFeedback =
            'Not quite. ${_items[_countIndex].word} has $target syllables.';
      }
    });
  }

  void _nextCountQuestion() {
    setState(() {
      _countIndex = (_countIndex + 1) % _items.length;
      _countAnswered = false;
      _countFeedback = null;
    });
  }

  String _normalizeSegmentation(String input) {
    final normalized = input
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[\s_/]+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
    return normalized;
  }

  void _checkSplitAnswer() {
    final current = _items[_splitIndex];
    final user = _normalizeSegmentation(_splitController.text);
    final expected = current.hyphenated;
    final isCorrect = user == expected;

    setState(() {
      if (isCorrect) {
        _splitCorrect++;
        _splitFeedback = 'Nice work. ${current.word} -> $expected';
      } else {
        _splitFeedback = 'Try again. One correct split is: $expected';
      }
    });
  }

  void _nextSplitQuestion() {
    setState(() {
      _splitIndex = (_splitIndex + 1) % _items.length;
      _splitFeedback = null;
      _splitController.clear();
    });
  }

  void _checkStressAnswer() {
    if (_selectedStress == null) {
      setState(() {
        _stressFeedback = 'Select a syllable first.';
      });
      return;
    }

    final current = _items[_stressIndex];
    final isCorrect = _selectedStress == current.stressedIndex;

    setState(() {
      if (isCorrect) {
        _stressCorrect++;
        _stressFeedback =
            'Correct. Stress is on "${current.syllables[current.stressedIndex]}".';
      } else {
        _stressFeedback =
            'Not quite. Stress is on "${current.syllables[current.stressedIndex]}".';
      }
    });
  }

  void _nextStressQuestion() {
    setState(() {
      _stressIndex = (_stressIndex + 1) % _items.length;
      _selectedStress = null;
      _stressFeedback = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final countItem = _items[_countIndex];
    final splitItem = _items[_splitIndex];
    final stressItem = _items[_stressIndex];
    final countChoices = _getCountChoices(_countIndex);

    return Scaffold(
      appBar: AppBar(title: const Text('Syllables Practice')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Practice strategy',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Use a 3-step routine: (1) count syllable beats, (2) split the word into chunks, (3) identify where the primary stress lands.',
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1) Count Syllables',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Say the word aloud and tap one beat per vowel nucleus.',
                    ),
                    const SizedBox(height: 12),
                    Text(
                      countItem.word,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: countChoices.map((choice) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(64, 44),
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                          ),
                          onPressed: () => _checkCountAnswer(choice),
                          child: Text('$choice'),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    if (_countFeedback != null) Text(_countFeedback!),
                    const SizedBox(height: 8),
                    Text('Score: $_countCorrect'),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: _nextCountQuestion,
                      child: const Text('Next word'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2) Split Into Syllables',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Type the segmentation with hyphens, for example: ba-na-na',
                    ),
                    const SizedBox(height: 12),
                    Text(
                      splitItem.word,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _splitController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter syllables with hyphens',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 44),
                          ),
                          onPressed: _checkSplitAnswer,
                          child: const Text('Check'),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: _nextSplitQuestion,
                          child: const Text('Next word'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (_splitFeedback != null) Text(_splitFeedback!),
                    Text('Score: $_splitCorrect'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3) Find Primary Stress',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    const Text('Select the syllable that sounds strongest.'),
                    const SizedBox(height: 12),
                    Text(
                      stressItem.word,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(stressItem.syllables.length, (i) {
                        return ChoiceChip(
                          label: Text('${i + 1}. ${stressItem.syllables[i]}'),
                          selected: _selectedStress == i,
                          onSelected: (_) {
                            setState(() {
                              _selectedStress = i;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(140, 44),
                          ),
                          onPressed: _checkStressAnswer,
                          child: const Text('Check stress'),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: _nextStressQuestion,
                          child: const Text('Next word'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (_stressFeedback != null) Text(_stressFeedback!),
                    Text('Score: $_stressCorrect'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SyllableItem {
  const SyllableItem({
    required this.word,
    required this.syllables,
    required this.stressedIndex,
  });

  final String word;
  final List<String> syllables;
  final int stressedIndex;

  int get syllableCount => syllables.length;
  String get hyphenated => syllables.join('-');
}
