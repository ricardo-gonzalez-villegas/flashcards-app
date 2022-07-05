import 'dart:collection';
import 'package:flutter/material.dart';

Container miniFlashcard(LinkedHashMap<String, dynamic> flashcardData) {
  String word = flashcardData["word"];
  return Container(
    margin: const EdgeInsets.all(3),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 39, 38, 38).withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
          )
        ]),
    key: UniqueKey(),
    child: Center(
      child: Text(
        word,
        style: TextStyle(
          fontSize: word.length > 10 ? 14 : 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
