import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../components/flashcard_model.dart';
import '../components/flashcard_filters.dart';
import '../components/flashcard_page_view.dart';

class PhoneticsFlashcardsPage extends StatefulWidget {
  const PhoneticsFlashcardsPage({super.key});

  @override
  State<PhoneticsFlashcardsPage> createState() => _PhoneticsFlashcardsPageState();
}

class _PhoneticsFlashcardsPageState extends State<PhoneticsFlashcardsPage> {
  List<Flashcard> allCards = [];
  List<Flashcard> filteredCards = [];

  String filterType = 'all';
  String filterFeature = 'all';

  @override
  void initState() {
    super.initState();
    loadFlashcards();
  }

  void shuffleCards() {
    setState(() {
      filteredCards.shuffle();
    });
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

  String buildBackText(Flashcard card) {
    switch (filterFeature) {
      case 'place':
        return card.place;
      case 'manner':
        return card.manner;
      case 'voicing':
        return card.voicing;
      case 'all':
        return 'Place: ${card.place}\nManner: ${card.manner}\nVoicing: ${card.voicing}';
      default:
        return '${card.place}, ${card.manner}, ${card.voicing}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phonetics Flashcards')),
      body: Column(
        children: [
          FlashcardFilters(
            filterType: filterType,
            filterFeature: filterFeature,
            onTypeChanged: (value) {
              setState(() {
                filterType = value;
                applyFilter();
              });
            },
            onFeatureChanged: (value) {
              setState(() {
                filterFeature = value;
              });
            },
          ),

          Expanded(
            child: FlashcardPageView(
              cards: filteredCards,
              backTextBuilder: buildBackText,
              onShuffle: shuffleCards,
            ),
          ),
        ],
      ),
    );
  }
}
