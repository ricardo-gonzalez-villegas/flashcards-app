import 'dart:collection';

import 'package:flutter/material.dart';

class FlashcardTile extends StatelessWidget {
  const FlashcardTile({super.key, required this.flashcardData});
  final LinkedHashMap<String, dynamic> flashcardData;

  @override
  Widget build(BuildContext context) {
    List? tagsList;
    String tags = "Tags: ";
    if (flashcardData["tags"] != null) {
      tagsList = flashcardData["tags"];
      for (var i = 0; i < tagsList!.length; i++) {
        tags += '${tagsList[i]}, ';
      }
      tags = tags.substring(0, tags.length - 2);
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Color.fromARGB(255, 215, 215, 215),
          ),
        ),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(children: [
              Container(
                child: Text(
                  flashcardData["word"],
                  style: TextStyle(fontSize: 15),
                ),
              )
            ]),
            Text(
              tags,
              style: TextStyle(fontSize: 10, color: Colors.grey),
            )
          ]),
    );
  }
}
