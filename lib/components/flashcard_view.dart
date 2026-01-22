import 'dart:math';
import 'package:flutter/material.dart';
import 'flashcard_model.dart';

class FlashcardView extends StatelessWidget {
  final Flashcard card;
  final bool showBack;
  final String Function(Flashcard) backTextBuilder;

  const FlashcardView({
    super.key,
    required this.card,
    required this.showBack,
    required this.backTextBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        final rotate = Tween(begin: pi, end: 0.0).animate(animation);

        return AnimatedBuilder(
          animation: rotate,
          builder: (context, childWidget) {
            final isBack = childWidget!.key == const ValueKey('back');

            // Flip smoothly without wobble
            final angle = isBack ? rotate.value : -rotate.value;

            return Transform(
              transform: Matrix4.rotationY(angle),
              alignment: Alignment.center,
              child: childWidget,
            );
          },
          child: child,
        );
      },
      child: showBack ? _buildBack() : _buildFront(),
    );
  }

  Widget _buildFront() {
    return Container(
      key: const ValueKey('front'),
      width: 300,
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Center(
        child: Text(
          card.symbol,
          style: const TextStyle(fontSize: 64),
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      key: const ValueKey('back'),
      width: 300,
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(color: Colors.blue.shade50),
      child: Text(
        backTextBuilder(card),
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  BoxDecoration _cardDecoration({Color color = Colors.white}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
    );
  }
}
