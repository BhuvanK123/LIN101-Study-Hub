import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// 1. Flashcard model
class Flashcard {
  final String symbol;
  final String type;
  final String place;
  final String manner;
  final String voicing;

  Flashcard(this.symbol, this.type, this.place, this.manner, this.voicing);
}

// 2. Stateful widget
class PhoneticsFlashcardsPage extends StatefulWidget {
  @override
  _PhoneticsFlashcardsPageState createState() => _PhoneticsFlashcardsPageState();
}

class _PhoneticsFlashcardsPageState extends State<PhoneticsFlashcardsPage> {
  List<Flashcard> allCards = [];
  List<Flashcard> filteredCards = [];

  String filterType = 'all';
  String filterFeature = 'manner';

  @override
  void initState() {
    super.initState();
    loadFlashcards();
  }

  Future<void> loadFlashcards() async {
    final data = await rootBundle.loadString('assets/phonetics_data.txt');
    final lines = data.split('\n');

    final cards = lines.where((line) => line.trim().isNotEmpty).map((line) {
      final parts = line.split('|');
      return Flashcard(parts[0], parts[1], parts[2], parts[3], parts[4]);
    }).toList();

    setState(() {
      allCards = cards;
      filteredCards = cards;
    });
  }

  void applyFilter() {
    setState(() {
      filteredCards = allCards.where((card) {
        return filterType == 'all' || card.type == filterType;
      }).toList();
    });
  }

  Widget buildFlashcard(Flashcard card) {
    String backText;
    switch (filterFeature) {
      case 'place':
        backText = card.place;
        break;
      case 'manner':
        backText = card.manner;
        break;
      case 'voicing':
        backText = card.voicing;
        break;
      case 'all':
        backText = 'Place: ${card.place}\nManner: ${card.manner}\nVoicing: ${card.voicing}';
        break;
      default:
        backText = '${card.place}, ${card.manner}, ${card.voicing}';
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(card.symbol, style: const TextStyle(fontSize: 24)),
        subtitle: Text(backText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phonetics Flashcards')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: filterType,
                    isExpanded: true,
                    items: ['all', 'vowel', 'consonant'].map((type) {
                      return DropdownMenuItem(value: type, child: Text('Type: $type'));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        filterType = value!;
                        applyFilter();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String>(
                    value: filterFeature,
                    isExpanded: true,
                    items: ['manner', 'place', 'voicing', 'all'].map((feature) {
                      return DropdownMenuItem(value: feature, child: Text('Feature: $feature'));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        filterFeature = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCards.length,
              itemBuilder: (context, index) {
                return buildFlashcard(filteredCards[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
