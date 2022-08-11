import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

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

  void _clearFields() {
    _wordController.clear();
    _descriptionController.clear();
    _tagsController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            Container(
              margin: const EdgeInsets.all(40),
              child: TextFormField(
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
                  )),
            ),
            TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: "Tags",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                )),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _flashcardsCollection.add({
                    "user_id": FirebaseAuth.instance.currentUser?.uid,
                    "word": _wordController.text.toUpperCase(),
                    "description": _descriptionController.text,
                    "tags": _tagsController.text
                        .toUpperCase()
                        .replaceAll(RegExp(' '), '')
                        .split(','),
                    "missed": 0,
                    "correct": 0,
                    "studied": 0,
                    "favorite": false,
                    "created_at": timeStamp,
                  }).then((value) {
                    DocumentReference doc = FirebaseFirestore.instance
                        .collection("flashcards")
                        .doc(value.id);
                    doc.update({"document_id": value.id});
                    _clearFields();
                    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
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
