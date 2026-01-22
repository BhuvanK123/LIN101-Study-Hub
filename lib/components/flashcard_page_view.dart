import 'package:flutter/material.dart';
import 'flashcard_model.dart';
import 'flashcard_view.dart';

class FlashcardPageView extends StatefulWidget {
  final List<Flashcard> cards;
  final String Function(Flashcard) backTextBuilder;
  final VoidCallback onShuffle;
  const FlashcardPageView({
    super.key,
    required this.cards,
    required this.backTextBuilder,
    required this.onShuffle,
  });

  @override
  State<FlashcardPageView> createState() => _FlashcardPageViewState();
}

class _FlashcardPageViewState extends State<FlashcardPageView> {
  int index = 0;
  bool showBack = false;

  void nextCard() {
    if (index < widget.cards.length - 1) {
      setState(() {
        index++;
        showBack = false;
      });
    }
  }

  void previousCard() {
    if (index > 0) {
      setState(() {
        index--;
        showBack = false;
      });
    }
  }

  @override
  void didUpdateWidget(covariant FlashcardPageView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the card list changes (due to filtering), reset to the first card
    if (oldWidget.cards != widget.cards) {
      setState(() {
        index = 0;
        showBack = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.cards[index];

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => showBack = !showBack),
            child: Center(
              child: FlashcardView(
                card: card,
                showBack: showBack,
                backTextBuilder: widget.backTextBuilder,
              ),
            ),
          ),
        ),

        // ARROWS + PROGRESS
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 40,
                icon: const Icon(Icons.arrow_left),
                onPressed: previousCard,
              ),
              Text(
                "Card ${index + 1} of ${widget.cards.length}",
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                iconSize: 40,
                icon: const Icon(Icons.arrow_right),
                onPressed: nextCard,
              ),

              IconButton(
                iconSize: 32,
                icon: const Icon(Icons.shuffle),
                onPressed: () {
                  widget.onShuffle();
                  setState(() {
                    index = 0;
                    showBack = false;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
