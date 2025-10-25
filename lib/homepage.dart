import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Map<String, String>> features = [
    {'title': 'Phonetics', 'route': '/phonetics'},
    {'title': 'Morphology', 'route': '/morphology'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LIN101 Study Hub')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: features.map((feature) {
            return ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, feature['route']!);
                },
                child: Text(feature['title']!),
            );
          }).toList(),
        ),
      )
    );
  }
}
