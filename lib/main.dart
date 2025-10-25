import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(const Lin101App());
}

class Lin101App extends StatelessWidget {
  const Lin101App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LIN101 Study Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomePage(),
      routes: {
        '/phonetics': (context) => PhoneticsPage(),
        '/morphology': (context) => MorphologyPage(),
      },
    );
  }
}

class PhoneticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phonetics')),
      body: Center(child: Text('Welcome to Phonetics!')),
    );
  }
}

class MorphologyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Morphology')),
      body: Center(child: Text('Welcome to Morphology!')),
    );
  }
}