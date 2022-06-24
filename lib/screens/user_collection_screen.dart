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
  late final Stream<QuerySnapshot> _flashcardsStream = FirebaseFirestore
      .instance
      .collection("flashcards")
      .where("user_id", isEqualTo: _userId)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Collection")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _flashcardsStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> flashcardSnapshot) {
          if (flashcardSnapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }
          List flashcardsList = flashcardSnapshot.data!.docs.toList();
          return ListView.builder(
            itemCount: flashcardsList.length,
            itemBuilder: (context, index) {
              LinkedHashMap<String, dynamic> flashcardData =
                  flashcardsList[index].data();
              return ListTile(
                key: UniqueKey(),
                title: Text(flashcardData["target_language"]),
              );
            },
          );
        },
      ),
    );
  }
}
