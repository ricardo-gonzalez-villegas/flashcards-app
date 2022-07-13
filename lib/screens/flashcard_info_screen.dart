import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards_app/screens/edit_screen.dart';
import 'package:flashcards_app/screens/user_collection_screen.dart';
import 'package:flashcards_app/utils/screensize_reducer.dart';
import 'package:flashcards_app/widgets/flashcard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FlashcardInfo extends StatefulWidget {
  const FlashcardInfo({super.key, required this.data});
  final LinkedHashMap<String, dynamic> data;

  @override
  State<FlashcardInfo> createState() => _FlashcardInfoState();
}

class _FlashcardInfoState extends State<FlashcardInfo> {
  CollectionReference flashcardsCollection =
      FirebaseFirestore.instance.collection("flashcards");
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 84, 132, 235),
        appBar: AppBar(
          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.chevronLeft),
            onPressed: () => Navigator.pop(context),
          ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: const Text("Statistics"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flashcard(data: widget.data),
            Stats(data: widget.data),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.circleChevronUp),
              iconSize: 40,
              color: Colors.white,
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: screenHeight(context) / 3,
                      color: Colors.white,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.pen,
                              color: Color.fromARGB(255, 138, 138, 138),
                            ),
                            title: const Text(
                              "Edit",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 138, 138, 138)),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EditFlashcardScreen()),
                              );
                            },
                          ),
                          ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.trash,
                              color: Color.fromARGB(255, 138, 138, 138),
                            ),
                            title: const Text(
                              "Delete",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 138, 138, 138)),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UserCollectionScreen()),
                              );
                              flashcardsCollection
                                  .doc(widget.data["document_id"])
                                  .delete();
                            },
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class Stats extends StatelessWidget {
  const Stats({super.key, required this.data});
  final LinkedHashMap<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    String timesStudied = data["times_studied"].toString();
    String timesCorrect = data["times_correct"].toString();
    String timesMissed = data["times_missed"].toString();
    String percent =
        ((data["times_correct"] / data["times_studied"]) * 100.0).toString();
    String overallScore = timesStudied == "0" ? "100.0%" : "$percent%";

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          stat(context, "Correct", timesCorrect, FontAwesomeIcons.check,
              const Color.fromARGB(255, 117, 205, 120)),
          stat(context, "Missed", timesMissed, FontAwesomeIcons.xmark,
              const Color.fromARGB(255, 237, 95, 85))
        ],
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            stat(context, "Studied", timesStudied, FontAwesomeIcons.bookOpen,
                const Color.fromARGB(255, 108, 179, 238)),
            stat(context, "Overall", overallScore, FontAwesomeIcons.award,
                const Color.fromARGB(255, 241, 225, 79))
          ],
        ),
      ),
    ]);
  }
}

Container stat(BuildContext context, String text, String stat, IconData icon,
    Color color) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 39, 38, 38).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ]),
    height: 100,
    width: 180,
    child: Row(children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        width: 50,
        height: 50,
        child: Center(
            child: FaIcon(
          icon,
          color: Colors.black38,
        )),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 138, 138, 138),
                fontWeight: FontWeight.w500),
          ),
          Text(
            stat,
            style: const TextStyle(
                color: Color.fromARGB(255, 95, 94, 94),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )
        ],
      )
    ]),
  );
}
