import 'package:flutter/material.dart';

class CreateFlashcardScreen extends StatefulWidget {
  CreateFlashcardScreen({Key? key}) : super(key: key);

  @override
  State<CreateFlashcardScreen> createState() => _CreateFlashcardScreenState();
}

class _CreateFlashcardScreenState extends State<CreateFlashcardScreen> {
  final TextEditingController _targetLanguageController =
      TextEditingController();
  final TextEditingController _primaryLanguageController =
      TextEditingController();
  final TextEditingController _secondaryLanguageController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cardTextField("Target Language", _targetLanguageController),
            cardTextField("Primary Language", _primaryLanguageController),
            cardTextField("Secondary Language", _secondaryLanguageController),
            ElevatedButton(
                onPressed: () {
                  print("Flashcard Added");
                },
                child: Text("Add")),
          ],
        ),
      ),
    );
  }
}

TextField cardTextField(String text, TextEditingController controller) {
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
