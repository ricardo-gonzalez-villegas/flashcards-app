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
        front: CardFront(
          word: widget.data["word"],
          favorite: _favorite,
          update: _updateFavorite,
        ),
        back: CardBack(description: widget.data["description"]));
  }
}

class Flip extends StatefulWidget {
  const Flip({super.key, required this.front, required this.back});
  final Widget front;
  final Widget back;

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
      height: 300,
      width: screenWidth(context),
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

class CardFront extends StatelessWidget {
  const CardFront(
      {super.key,
      required this.word,
      required this.favorite,
      required this.update});
  final String word;
  final bool favorite;
  final VoidCallback update;

  @override
  Widget build(BuildContext context) {
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
      width: screenWidth(context, reducedBy: 20.0),
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
            margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
            child: Text(
              word,
              style: TextStyle(
                fontSize: word.length > 8 ? 40 : 50,
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

class CardBack extends StatelessWidget {
  const CardBack({super.key, required this.description});
  final String description;
  @override
  Widget build(BuildContext context) {
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
      width: screenWidth(context, reducedBy: 20.0),
      height: 300,
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Center(
          child: Text(description,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
