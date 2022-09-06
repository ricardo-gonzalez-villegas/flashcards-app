import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_app/screens/flashcard_info_screen.dart';
import 'package:flashcards_app/utils/screensize_reducer.dart';
import 'package:flashcards_app/widgets/bottom_nav_bar.dart';
import 'package:flashcards_app/widgets/flashcard_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserCollectionScreen extends StatefulWidget {
  const UserCollectionScreen({Key? key}) : super(key: key);

  @override
  State<UserCollectionScreen> createState() => _UserCollectionScreenState();
}

class _UserCollectionScreenState extends State<UserCollectionScreen> {
  final String _userId = FirebaseAuth.instance.currentUser!.uid;
  late Stream<QuerySnapshot> _flashcardsStream = FirebaseFirestore.instance
      .collection("flashcards")
      .where("user_id", isEqualTo: _userId)
      .snapshots();

  var _lists = ["All", "Favorites"];

  @override
  void initState() {
    super.initState();
    _getLists();
  }

  void _setLists(List<String> items) {
    setState(() {
      _lists += items;
    });
  }

  void _getLists() {
    FirebaseFirestore.instance
        .collection('lists')
        .where("user_id", isEqualTo: _userId)
        .get()
        .then(
      ((listItems) {
        List<String> items = [];
        for (var listItem in listItems.docs) {
          setState(
            () {
              items.add(listItem["list_name"]);
            },
          );
        }
        items.sort();
        _setLists(items);
      }),
    );
  }

  String? _filter;
  String _dropdownValue = "All";

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
              .where("tag", isEqualTo: tagFilter.toUpperCase())
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
              .where("tag", isEqualTo: tagFilter.toUpperCase())
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
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
        title: const Text("Collection"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => print("Help"),
              icon: const FaIcon(FontAwesomeIcons.circleInfo))
        ],
        backgroundColor: const Color.fromARGB(255, 84, 132, 235),
        shadowColor: Colors.transparent,
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
      body: SizedBox(
        width: screenWidth(context),
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 84, 132, 235),
              width: screenWidth(context),
              child: Container(
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
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                          items: _lists.map((String items) {
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
