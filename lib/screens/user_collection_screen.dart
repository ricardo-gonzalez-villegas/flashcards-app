import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_app/screens/create_screen.dart';
import 'package:flashcards_app/screens/flashcard_info_screen.dart';
import 'package:flashcards_app/screens/home_screen.dart';
import 'package:flashcards_app/utils/screensize_reducer.dart';
import 'package:flashcards_app/widgets/flashcard_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  void _onTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        break;

      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateFlashcardScreen(),
          ),
        );
        break;

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserCollectionScreen(),
          ),
        );
        break;
    }
  }

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
        title: const Text("Collection"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => print("Help"),
              icon: const FaIcon(FontAwesomeIcons.circleInfo))
        ],
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 84, 132, 235),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Study',
            backgroundColor: Color.fromARGB(255, 84, 132, 235),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add',
            backgroundColor: Color.fromARGB(255, 84, 132, 235),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'Collection',
            backgroundColor: Color.fromARGB(255, 84, 132, 235),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Color.fromARGB(255, 84, 132, 235),
          ),
        ],
        currentIndex: 3,
        onTap: _onTapped,
      ),
      body: SizedBox(
        width: screenWidth(context),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 39, 38, 38)
                          .withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                    )
                  ]),
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              width: 360,
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              width: 1.8,
                              color: Color.fromARGB(255, 215, 215, 215)),
                        ),
                      ),
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
                            fillColor: Colors.transparent,
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    decoration: const BoxDecoration(
                      // color: Color.fromARGB(150, 72, 117, 181),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    height: 50,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _dropdownValue,
                        items: _items.map((String items) {
                          return DropdownMenuItem(
                              value: items, child: Text(items));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _dropdownValue = newValue!;
                          });
                          _setStreamWithFilter();
                        },
                      ),
                    ),
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
    return StreamBuilder<QuerySnapshot>(
      stream: widget.flashcardsStream,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> flashcardSnapshot) {
        if (flashcardSnapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...',
              style: TextStyle(fontSize: 17, color: Colors.white));
        }
        List flashcardsList = flashcardSnapshot.data!.docs.toList();
        if (flashcardsList.isEmpty) {
          return const Text(
            "No results.",
            style: TextStyle(fontSize: 17, color: Colors.white),
          );
        }

        return Expanded(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: flashcardsList.length,
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
                        child: FlashcardTile(flashcardData: flashcardData),
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
