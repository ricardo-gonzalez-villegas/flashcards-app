import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_app/screens/flashcard_info_screen.dart';
import 'package:flashcards_app/screens/home_screen.dart';
import 'package:flashcards_app/utils/screensize_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/mini_flashcard.dart';

class UserCollectionScreen extends StatefulWidget {
  const UserCollectionScreen({Key? key}) : super(key: key);

  @override
  State<UserCollectionScreen> createState() => _UserCollectionScreenState();
}

class _UserCollectionScreenState extends State<UserCollectionScreen> {
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;
  late Stream<QuerySnapshot> _flashcardsStream = FirebaseFirestore.instance
      .collection("flashcards")
      .where("user_id", isEqualTo: _userId)
      .snapshots();
  String? _filter;
  String _dropdownValue = "All";
  final _items = ["All", "Favorites"];
  Timer? _stoppedTyping;

  void _onChangeHandler() {
    const duration = Duration(milliseconds: 1000); //
    if (_stoppedTyping != null) {
      setState(() => _stoppedTyping!.cancel());
    }

    setState(
      () => _stoppedTyping = Timer(duration, () {
        _setStreamWithFilter();
      }),
    );
  }

  void _setStreamWithFilter() {
    setState(() {
      if (_dropdownValue == "All") {
        if (_filter == null || _filter == "") {
          _flashcardsStream = FirebaseFirestore.instance
              .collection("flashcards")
              .where("user_id", isEqualTo: _userId)
              .snapshots();
          return;
        }

        if (_filter!.startsWith('#') == true) {
          String tagFilter = _filter!.substring(1);
          _flashcardsStream = FirebaseFirestore.instance
              .collection("flashcards")
              .where("user_id", isEqualTo: _userId)
              .where("tags", arrayContains: tagFilter.toUpperCase())
              .snapshots();
        } else {
          _flashcardsStream = FirebaseFirestore.instance
              .collection("flashcards")
              .where("user_id", isEqualTo: _userId)
              .where("word", isEqualTo: _filter?.toUpperCase())
              .snapshots();
        }
      }

      if (_dropdownValue == "Favorites") {
        if (_filter == null || _filter == "") {
          _flashcardsStream = FirebaseFirestore.instance
              .collection("flashcards")
              .where("user_id", isEqualTo: _userId)
              .where("favorite", isEqualTo: true)
              .snapshots();
          return;
        }

        if (_filter!.startsWith('#') == true) {
          String tagFilter = _filter!.substring(1);
          _flashcardsStream = FirebaseFirestore.instance
              .collection("flashcards")
              .where("user_id", isEqualTo: _userId)
              .where("tags", arrayContains: tagFilter.toUpperCase())
              .where("favorite", isEqualTo: true)
              .snapshots();
        } else {
          _flashcardsStream = FirebaseFirestore.instance
              .collection("flashcards")
              .where("user_id", isEqualTo: _userId)
              .where("word", isEqualTo: _filter?.toUpperCase())
              .where("favorite", isEqualTo: true)
              .snapshots();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 84, 132, 235),
      appBar: AppBar(
        leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.houseChimneyUser),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            }),
        title: const Text("Collection"),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: SizedBox(
        width: screenWidth(context),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
              ),
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              width: 360,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        _filter = value;
                        _onChangeHandler();
                      },
                      enableSuggestions: true,
                      autocorrect: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        labelText: "Search",
                        filled: true,
                      ),
                    ),
                  ),
                  DropdownButton(
                    value: _dropdownValue,
                    items: _items.map((String items) {
                      return DropdownMenuItem(value: items, child: Text(items));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _dropdownValue = newValue!;
                      });
                      _setStreamWithFilter();
                    },
                  )
                ],
              ),
            ),
            UserCollection(
              flashcardsStream: _flashcardsStream,
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class UserCollection extends StatefulWidget {
  UserCollection({super.key, required this.flashcardsStream});
  Stream<QuerySnapshot> flashcardsStream;

  @override
  State<UserCollection> createState() => _UserCollectionState();
}

class _UserCollectionState extends State<UserCollection> {
  @override
  Widget build(BuildContext context) {
    final double itemHeight = (screenHeight(context) - 100) / 3;
    final double itemWidth = screenWidth(context) / 2;
    return StreamBuilder<QuerySnapshot>(
      stream: widget.flashcardsStream,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> flashcardSnapshot) {
        if (flashcardSnapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }
        List flashcardsList = flashcardSnapshot.data!.docs.toList();
        if (flashcardsList.isEmpty) {
          return const Text("Nothing found");
        }

        return Expanded(
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                    itemCount: flashcardsList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: (itemHeight / itemWidth),
                    ),
                    itemBuilder: (context, index) {
                      LinkedHashMap<String, dynamic> flashcardData =
                          flashcardsList[index].data();
                      return GestureDetector(
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FlashcardInfo(data: flashcardData),
                                ),
                              ),
                          child: miniFlashcard(flashcardData));
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
