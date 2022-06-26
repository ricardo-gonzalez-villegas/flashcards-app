import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateFlashcardScreen extends StatefulWidget {
  const CreateFlashcardScreen({Key? key}) : super(key: key);

  @override
  State<CreateFlashcardScreen> createState() => _CreateFlashcardScreenState();
}

class _CreateFlashcardScreenState extends State<CreateFlashcardScreen> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _primaryLanguageController =
      TextEditingController();
  final TextEditingController _secondaryLanguageController =
      TextEditingController();
  final CollectionReference _flashcardsCollection =
      FirebaseFirestore.instance.collection("flashcards");
  final FocusNode _focusNode = FocusNode();
  final _snackBar = const SnackBar(content: Text("Sucessfully Added"));

  void _clearFields() {
    _wordController.clear();
    _primaryLanguageController.clear();
    _secondaryLanguageController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    Uuid uuid = const Uuid();
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              focusNode: _focusNode,
              autofocus: true,
              controller: _wordController,
              enableSuggestions: true,
              autocorrect: true,
              decoration: const InputDecoration(
                labelText: "Word",
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            flashcardTextField("Primary Language", _primaryLanguageController),
            flashcardTextField(
                "Secondary Language", _secondaryLanguageController),
            ElevatedButton(
              onPressed: () {
                _flashcardsCollection.add({
                  "id": uuid.v4(),
                  "user_id": FirebaseAuth.instance.currentUser?.uid,
                  "word": _wordController.text.toUpperCase(),
                  "primary_language":
                      _primaryLanguageController.text.toUpperCase(),
                  "secondary_language":
                      _secondaryLanguageController.text.toUpperCase(),
                  "times_missed": 0,
                  "times_correct": 0,
                  "times_studied": 0,
                  "favorite": false
                }).then((value) {
                  _clearFields();
                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                });

                //add error handling
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}

TextField flashcardTextField(String text, TextEditingController controller) {
  return TextField(
    controller: controller,
    enableSuggestions: true,
    autocorrect: true,
    decoration: InputDecoration(
      labelText: text,
      floatingLabelBehavior: FloatingLabelBehavior.never,
    ),
  );
}
