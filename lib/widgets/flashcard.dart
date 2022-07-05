import 'dart:collection';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards_app/utils/screensize_reducer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Flashcard extends StatefulWidget {
  const Flashcard({super.key, required this.data});
  final LinkedHashMap<String, dynamic> data;

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  late bool _favorite = widget.data["favorite"];
  late final DocumentReference flashcardDoc = FirebaseFirestore.instance
      .collection("flashcards")
      .doc(widget.data["document_id"]);

  void _updateFavorite() {
    setState(() {
      _favorite = !_favorite;
    });
    flashcardDoc.update({"favorite": _favorite});
  }

  @override
  Widget build(BuildContext context) {
    return Flip(
        front: cardFront(widget.data["word"], _favorite, _updateFavorite),
        back: cardBack(
          widget.data["furigana"],
          widget.data["primary_language"],
          widget.data["secondary_language"],
        ));
  }
}

class Flip extends StatefulWidget {
  const Flip({super.key, required this.front, required this.back});
  final Container front;
  final Container back;

  @override
  State<Flip> createState() => _FlipState();
}

class _FlipState extends State<Flip> with SingleTickerProviderStateMixin {
  double value = 0.0;
  late final AnimationController _animationController;
  late Animation rotation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    rotation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutQuart));

    _animationController.addListener(() {
      setState(() {
        value = _animationController.value;
      });
    });

    super.initState();
  }

  void flipCard() {
    if (_animationController.isCompleted ||
        _animationController.status == AnimationStatus.forward) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: GestureDetector(
        onTap: () => flipCard(),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (rotation.value < 0.5) ...[
            Transform(
                transform: Matrix4.rotationX(pi * rotation.value),
                alignment: FractionalOffset.center,
                child: widget.front),
          ] else ...[
            Transform(
                transform: Matrix4.rotationX(pi * (1 - rotation.value)),
                alignment: FractionalOffset.center,
                child: widget.back)
          ],
        ]),
      ),
    );
  }
}

Container cardFront(String word, bool favorite, VoidCallback update) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 39, 38, 38).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ]),
    width: 400,
    height: 300,
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          width: 350,
          alignment: Alignment.centerRight,
          child: IconButton(
              onPressed: () => update(),
              color: favorite
                  ? const Color.fromARGB(255, 228, 219, 118)
                  : const Color.fromARGB(255, 194, 194, 194),
              icon: const FaIcon(
                FontAwesomeIcons.solidBookmark,
                size: 50,
                // color: Colors.blue,
              )),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Text(
            word,
            style: TextStyle(
              fontSize: word.length > 4 ? 50 : 60,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}

Container cardBack(
  String? furigana,
  String primary,
  String secondary,
) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 39, 38, 38).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ]),
    width: 400,
    height: 300,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          furigana ?? "",
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(
          primary,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(secondary,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 39, 38, 38).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ]),
      width: 400,
      height: 300,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            width: 350,
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () => update(),
                color: favorite
                    ? const Color.fromARGB(255, 228, 219, 118)
                    : const Color.fromARGB(255, 194, 194, 194),
                icon: const FaIcon(
                  FontAwesomeIcons.solidBookmark,
                  size: 50,
                  // color: Colors.blue,
                )),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Text(
              word,
              style: TextStyle(
                fontSize: word.length > 4 ? 50 : 60,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
