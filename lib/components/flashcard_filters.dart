import 'package:flutter/material.dart';

class FlashcardFilters extends StatelessWidget {
  final String filterType;
  final String filterFeature;
  final Function(String) onTypeChanged;
  final Function(String) onFeatureChanged;

  const FlashcardFilters({
    super.key,
    required this.filterType,
    required this.filterFeature,
    required this.onTypeChanged,
    required this.onFeatureChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              onChanged: (value) => onTypeChanged(value!),
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
              onChanged: (value) => onFeatureChanged(value!),
            ),
          ),
        ],
      ),
    );
  }
}
