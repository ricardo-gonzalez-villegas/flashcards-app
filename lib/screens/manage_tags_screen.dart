import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      body: Column(children: const [CreateTagForm()]),
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

TextField reusableTextField(String text, IconData icon, bool isPassword,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    enableSuggestions: !isPassword,
    autocorrect: !isPassword,
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      labelText: text,
      filled: true,
    ),
    keyboardType:
        isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}

// class TagsDisplay extends StatefulWidget {
//   const TagsDisplay({Key? key}) : super(key: key);

//   @override
//   State<TagsDisplay> createState() => _TagsDisplayState();
// }

// class _TagsDisplayState extends State<TagsDisplay> {
//   @override
//   Widget build(BuildContext context) {}
// }
