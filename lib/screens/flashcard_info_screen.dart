import 'dart:collection';
import 'package:flashcards_app/widgets/flashcard.dart';
import 'package:flutter/material.dart';

class FlashcardInfo extends StatefulWidget {
  const FlashcardInfo({super.key, required this.data});
  final LinkedHashMap<String, dynamic> data;

  @override
  State<FlashcardInfo> createState() => _FlashcardInfoState();
}

class _FlashcardInfoState extends State<FlashcardInfo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 84, 132, 235),
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: const Text("Statistics"),
        ),
        body: Flashcard(data: widget.data),
      ),
    );
  }
}

class Stats extends StatelessWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
