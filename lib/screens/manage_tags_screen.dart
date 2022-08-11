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
  TextEditingController _tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        ElevatedButton(
            onPressed: () => print("Clicked"), child: const Text("Add"))
      ]),
    );
  }
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
