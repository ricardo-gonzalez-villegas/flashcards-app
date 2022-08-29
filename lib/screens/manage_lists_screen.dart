import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:uuid/uuid.dart';

class ManageListsScreen extends StatefulWidget {
  const ManageListsScreen({Key? key}) : super(key: key);

  @override
  State<ManageListsScreen> createState() => _ManageListsScreenState();
}

class _ManageListsScreenState extends State<ManageListsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 84, 132, 235),
        title: const Text("Lists"),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [CreateListForm(), ListDisplay()]),
    );
  }
}

class CreateListForm extends StatefulWidget {
  const CreateListForm({Key? key}) : super(key: key);

  @override
  State<CreateListForm> createState() => _CreateListForm();
}

class _CreateListForm extends State<CreateListForm> {
  final TextEditingController _listController = TextEditingController();
  final CollectionReference _listsCollection =
      FirebaseFirestore.instance.collection("lists");
  final Timestamp _timeStamp = Timestamp.fromDate(DateTime.now());

  void _onClick(String list) {
    var uuid = const Uuid().v4();
    _listsCollection.doc(uuid).set({
      "id": uuid,
      "user_id": FirebaseAuth.instance.currentUser?.uid,
      "list_name": list.toUpperCase(),
      "created_at": _timeStamp,
      "flashcard_ids": [],
    });
    _listController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 30, 0, 20),
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
                controller: _listController,
                autocorrect: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.list,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            //add swipe to delete widget
            child: GestureDetector(
              onTap: (() => _onClick(_listController.text)),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(255, 213, 188, 26),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 39, 38, 38)
                          .withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                    )
                  ],
                ),
                margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: const Center(
                  child: Text(
                    "Add",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ListDisplay extends StatefulWidget {
  const ListDisplay({Key? key}) : super(key: key);

  @override
  State<ListDisplay> createState() => _ListDisplayState();
}

class _ListDisplayState extends State<ListDisplay> {
  final Stream<QuerySnapshot> _listsStream = FirebaseFirestore.instance
      .collection("lists")
      .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  void _onSwipe(String uuid) {
    FirebaseFirestore.instance.collection("lists").doc(uuid).delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _listsStream,
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> listsSnapshot) {
        if (listsSnapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...',
              style: TextStyle(fontSize: 17, color: Colors.white));
        }
        List listsList = listsSnapshot.data!.docs.toList();
        if (listsList.isEmpty) {
          return const Center(
            child: Text(
              "No lists.",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        }

        return Expanded(
          flex: 7,
          child: ListView.builder(
            itemCount: listsList.length,
            itemBuilder: (context, index) {
              LinkedHashMap<String, dynamic> listData = listsList[index].data();
              return Dismissible(
                onDismissed: (direction) {
                  _onSwipe(listData["id"]);

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('List Deleted')));
                },
                key: UniqueKey(),
                child: listTile(
                  context,
                  listData["list_name"],
                  listData["flashcard_ids"],
                  Icons.list_sharp,
                  const Color.fromARGB(255, 233, 212, 77),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Container listTile(BuildContext context, String list, List flashcards,
    IconData icon, Color color) {
  return Container(
    margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 39, 38, 38).withOpacity(0.5),
          spreadRadius: 1,
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
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              list,
              style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 138, 138, 138),
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Flashcards: ${flashcards.length.toString()}',
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
