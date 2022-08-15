import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/bottom_nav_bar.dart';

class ManageTagsScreen extends StatefulWidget {
  const ManageTagsScreen({Key? key}) : super(key: key);

  @override
  State<ManageTagsScreen> createState() => _ManageTagsScreenState();
}

class _ManageTagsScreenState extends State<ManageTagsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 84, 132, 235),
        title: const Text("Tags"),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [CreateTagForm(), TagsListDisplay()]),
    );
  }
}

class CreateTagForm extends StatefulWidget {
  const CreateTagForm({Key? key}) : super(key: key);

  @override
  State<CreateTagForm> createState() => _CreateTagFormState();
}

class _CreateTagFormState extends State<CreateTagForm> {
  final TextEditingController _tagController = TextEditingController();
  final CollectionReference _tagsCollection =
      FirebaseFirestore.instance.collection("tags");
  final Timestamp _timeStamp = Timestamp.fromDate(DateTime.now());

  void _onClick(String tag) {
    _tagsCollection.add({
      "user_id": FirebaseAuth.instance.currentUser?.uid,
      "tag_name": tag.toUpperCase(),
      "created_at": _timeStamp,
      "flashcard_ids": [],
    });
    _tagController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                color: const Color.fromARGB(255, 215, 215, 215),
                child: TextField(
                  controller: _tagController,
                  autocorrect: true,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(
                    Icons.tag,
                  )),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              //reformart elevated button into container button
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: ElevatedButton(
                    onPressed: () => _onClick(_tagController.text),
                    child: const Text("Add")),
              ),
            )
          ]),
    );
  }
}

class TagsListDisplay extends StatefulWidget {
  const TagsListDisplay({Key? key}) : super(key: key);

  @override
  State<TagsListDisplay> createState() => _TagsListDisplayState();
}

class _TagsListDisplayState extends State<TagsListDisplay> {
  final Stream<QuerySnapshot> _tagsStream = FirebaseFirestore.instance
      .collection("tags")
      .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _tagsStream,
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> tagsSnapshot) {
        if (tagsSnapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...',
              style: TextStyle(fontSize: 17, color: Colors.white));
        }
        List tagsList = tagsSnapshot.data!.docs.toList();
        if (tagsList.isEmpty) {
          return const Text(
            "No results.",
            style: TextStyle(fontSize: 17, color: Colors.white),
          );
        }

        return Expanded(
          flex: 7,
          child: ListView.builder(
              itemCount: tagsList.length,
              itemBuilder: (context, index) {
                LinkedHashMap<String, dynamic> tagData = tagsList[index].data();
                return tagTile(
                    context,
                    tagData["tag_name"],
                    tagData["flashcard_ids"],
                    Icons.tag_sharp,
                    const Color.fromARGB(255, 76, 104, 175));
              }),
        );
      },
    );
  }
}

Container tagTile(BuildContext context, String tag, List flashcards,
    IconData icon, Color color) {
  return Container(
    margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 39, 38, 38).withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
        )
      ],
    ),
    height: 100,
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color,
          ),
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          width: 50,
          height: 50,
          child: Center(
              child: FaIcon(
            icon,
            color: Colors.black38,
          )),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tag,
              style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 138, 138, 138),
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Flashcards with tag: ${flashcards.length.toString()}',
              style: const TextStyle(
                  color: Color.fromARGB(255, 95, 94, 94),
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            )
          ],
        )
      ],
    ),
  );
}
