import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    const duration = Duration(milliseconds: 900); //
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

        _flashcardsStream = FirebaseFirestore.instance
            .collection("flashcards")
            .where("user_id", isEqualTo: _userId)
            .where("word", isEqualTo: _filter?.toUpperCase())
            .snapshots();
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

        _flashcardsStream = FirebaseFirestore.instance
            .collection("flashcards")
            .where("user_id", isEqualTo: _userId)
            .where("word", isEqualTo: _filter?.toUpperCase())
            .where("favorite", isEqualTo: true)
            .snapshots();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Collection")),
      body: Container(
        color: const Color.fromARGB(255, 228, 88, 88),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              width: 340,
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
                        return DropdownMenuItem(
                            value: items, child: Text(items));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownValue = newValue!;
                        });
                        _setStreamWithFilter();
                      })
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
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - 100) / 3;
    final double itemWidth = size.width / 2;
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
          child: GridView.builder(
              itemCount: flashcardsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: (itemWidth / itemHeight),
              ),
              itemBuilder: (context, index) {
                LinkedHashMap<String, dynamic> flashcardData =
                    flashcardsList[index].data();
                return miniFlashcard(flashcardData);
              }),
        );
      },
    );
  }
}

Container miniFlashcard(LinkedHashMap<String, dynamic> flashcardData) {
  return Container(
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 39, 38, 38).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ]),
    key: UniqueKey(),
    child: Center(
        child: Text(
      flashcardData["word"],
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    )),
  );
}
