import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FlashcardTile extends StatelessWidget {
  const FlashcardTile({super.key, required this.flashcardData});
  final LinkedHashMap<String, dynamic> flashcardData;

  @override
  Widget build(BuildContext context) {
    String tag = "Tag: ";
    if (flashcardData["tag"] != null) {
      tag += flashcardData["tag"];
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Text(
                    flashcardData["word"],
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (flashcardData["favorite"] == true) ...[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: FaIcon(
                        FontAwesomeIcons.solidBookmark,
                        color: Color.fromARGB(255, 228, 219, 118),
                        size: 20,
                      ),
                    )
                  ],
                ],
              ),
              Text(
                tag,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
          const FaIcon(
            FontAwesomeIcons.chevronRight,
            color: Color.fromARGB(255, 215, 215, 215),
            size: 14,
          )
        ],
      ),
    );
  }
}
