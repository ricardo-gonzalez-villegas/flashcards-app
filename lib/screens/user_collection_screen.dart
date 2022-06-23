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
  late final Stream<QuerySnapshot> _flashcardsStream = FirebaseFirestore
      .instance
      .collection("flashcards")
      .where("user_id", isEqualTo: _userId)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _flashcardsStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> flashcardSnapshot) {
          List flashcardsList = flashcardSnapshot.data!.docs.toList();
          print(flashcardsList);
          print(flashcardsList[1].data());
          return Text("Flashcard");
        });
  }
}
