import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateFlashcardScreen extends StatefulWidget {
  const CreateFlashcardScreen({Key? key}) : super(key: key);

  @override
  State<CreateFlashcardScreen> createState() => _CreateFlashcardScreenState();
}

class _CreateFlashcardScreenState extends State<CreateFlashcardScreen> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  final CollectionReference _flashcardsCollection =
      FirebaseFirestore.instance.collection("flashcards");
  Timestamp timeStamp = Timestamp.fromDate(DateTime.now());

  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _snackBar = const SnackBar(content: Text("Sucessfully Added"));

  List<String> _lists = [];
  List<String> _tags = [];
  String? _listsDropdownValue;
  String? _tagsDropdownValue;
  Map _listMap = <String, String>{};
  Map _tagMap = <String, String>{};

  void _clearFields() {
    _wordController.clear();
    _descriptionController.clear();
    _tagsController.clear();
    _focusNode.requestFocus();
  }

  @override
  void initState() {
    super.initState();
    _getLists();
    _getTags();
  }

  void _setLists(List<String> items) {
    setState(() {
      _lists = items;
      _listsDropdownValue = items[0];
    });
  }

  void _setTags(List<String> items) {
    setState(() {
      _tags = items;
      _tagsDropdownValue = items[0];
    });
  }

  void _setListMap(Map listMap) {
    setState(() {
      _listMap = listMap;
    });
  }

  void _setTagMap(Map tagMap) {
    setState(() {
      _tagMap = tagMap;
    });
  }

  void _getLists() {
    FirebaseFirestore.instance
        .collection('lists')
        .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      ((listItems) {
        List<String> items = [];
        Map lists = <String, String>{};
        for (var listItem in listItems.docs) {
          setState(
            () {
              items.add(listItem["list_name"]);
              lists[listItem["list_name"]] = listItem["id"];
            },
          );
        }
        items.sort();
        _setListMap(lists);
        _setLists(items);
      }),
    );
  }

  void _getTags() {
    FirebaseFirestore.instance
        .collection('tags')
        .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      ((tagItems) {
        List<String> items = [];
        Map tags = <String, String>{};
        for (var tagItem in tagItems.docs) {
          setState(
            () {
              items.add(tagItem["tag_name"]);
              tags[tagItem["tag_name"]] = tagItem["id"];
            },
          );
        }
        items.sort();
        _setTags(items);
        _setTagMap(tags);
      }),
    );
  }

  void _updateListFlashcardIds(String flashcardId) {
    List<dynamic> flashcardIds = [];

    FirebaseFirestore.instance
        .collection("lists")
        .doc(_listMap[_listsDropdownValue])
        .get()
        .then(
          (ids) => {
            flashcardIds = ids["flashcard_ids"],
          },
        )
        .then(
          (value) => {
            flashcardIds.add(flashcardId),
            FirebaseFirestore.instance
                .collection("lists")
                .doc(_listMap[_listsDropdownValue])
                .update({"flashcard_ids": flashcardIds})
          },
        );
  }

  void _updateTagFlashcardIds(String flashcardId) {
    List<dynamic> flashcardIds = [];

    FirebaseFirestore.instance
        .collection("tags")
        .doc(_tagMap[_tagsDropdownValue])
        .get()
        .then(
          (ids) => {
            flashcardIds = ids["flashcard_ids"],
          },
        )
        .then((value) => {
              flashcardIds.add(flashcardId),
              FirebaseFirestore.instance
                  .collection("tags")
                  .doc(_tagMap[_tagsDropdownValue])
                  .update({"flashcard_ids": flashcardIds}),
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            //Word Input
            TextFormField(
              focusNode: _focusNode,
              autofocus: true,
              controller: _wordController,
              enableSuggestions: true,
              autocorrect: true,
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter text.';
                }
                return null;
              }),
              decoration: const InputDecoration(
                labelText: "Word",
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            //Description Input
            TextFormField(
              controller: _descriptionController,
              maxLines: 8,
              maxLength: 300,
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter text.';
                }
                return null;
              }),
              decoration: const InputDecoration(
                labelText: "Description",
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            if (_lists.isNotEmpty) ...[
              DropdownButton<String>(
                value: _listsDropdownValue,
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? newValue) {
                  setState(() {
                    _listsDropdownValue = newValue!;
                  });
                },
                items: _lists.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ],

            if (_tags.isNotEmpty) ...[
              DropdownButton<String>(
                value: _tagsDropdownValue,
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? newValue) {
                  setState(() {
                    _tagsDropdownValue = newValue!;
                  });
                },
                items: _tags.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ],
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  var uuid = const Uuid().v4();

                  _flashcardsCollection.doc(uuid).set({
                    "id": uuid,
                    "user_id": FirebaseAuth.instance.currentUser?.uid,
                    "word": _wordController.text.toUpperCase(),
                    "description": _descriptionController.text,
                    "tag": _tagsDropdownValue,
                    "list": _listsDropdownValue,
                    "missed": 0,
                    "correct": 0,
                    "studied": 0,
                    "favorite": false,
                    "created_at": timeStamp,
                  }).then((value) {
                    _clearFields();
                    ScaffoldMessenger.of(context).showSnackBar(_snackBar);

                    _updateListFlashcardIds(uuid);
                    _updateTagFlashcardIds(uuid);
                  });
                }
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
