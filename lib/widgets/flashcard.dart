import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Flashcard extends StatefulWidget {
  const Flashcard({Key? key}) : super(key: key);

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  @override
  Widget build(BuildContext context) {
    return const Flip();
  }
}

class Flip extends StatefulWidget {
  const Flip({Key? key}) : super(key: key);

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
                transform: Matrix4.rotationY(pi * rotation.value),
                alignment: FractionalOffset.center,
                child: cardFront("携帯電話")),
          ] else ...[
            Transform(
                transform: Matrix4.rotationY(pi * (1 - rotation.value)),
                alignment: FractionalOffset.center,
                child: cardBack())
          ],
        ]),
      ),
    );
  }
}

Container cardFront(String word) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 39, 38, 38).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ]),
    width: 360,
    height: 500,
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          width: 280,
          alignment: Alignment.centerRight,
          child: IconButton(
              onPressed: () => print("bookmark pressed"),
              color: const Color.fromARGB(255, 228, 219, 118),
              icon: const FaIcon(
                FontAwesomeIcons.solidBookmark,
                size: 60,
                // color: Colors.blue,
              )),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 120, 0, 0),
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

Container cardBack() {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 39, 38, 38).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ]),
    width: 360,
    height: 500,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Text(
          "けいたいでんわ",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(
          "English",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text("Spanish",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
