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

  void setStreamWithFilter() {
    setState(() {
      if (_filter!.isEmpty) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Collection")),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              _filter = value;
              print(_filter);
              setStreamWithFilter();
            },
            enableSuggestions: true,
            autocorrect: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: "Search",
              filled: true,
            ),
          ),
          UserCollection(
            flashcardsStream: _flashcardsStream,
          ),
        ],
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
          return const Text('Loading');
        }
        List flashcardsList = flashcardSnapshot.data!.docs.toList();
        return Expanded(
          child: ListView.builder(
            itemCount: flashcardsList.length,
            itemBuilder: (context, index) {
              LinkedHashMap<String, dynamic> flashcardData =
                  flashcardsList[index].data();
              return ListTile(
                key: UniqueKey(),
                title: Text(flashcardData["word"]),
              );
            },
          ),
        );
      },
    );
  }
}

// Row customSearchBar() {
//   return Row(
//     children: [
//      DropdownButtonFormField(
//                   value: "Word",                 
//                   items: <String>['Low', 'Med', 'High']
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     _priority = newValue!;
//                   },
//                 ),
//       TextField(),
//     ],
//   );
// }
