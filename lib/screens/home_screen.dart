import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_app/screens/settings_screen.dart';
import 'package:flashcards_app/screens/user_collection_screen.dart';
import 'package:flashcards_app/screens/create_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _onTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        break;

      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateFlashcardScreen(),
          ),
        );
        break;

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserCollectionScreen(),
          ),
        );
        break;

      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsScreen(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 84, 132, 235),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Study',
            backgroundColor: Color.fromARGB(255, 84, 132, 235),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add',
            backgroundColor: Color.fromARGB(255, 84, 132, 235),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'Collection',
            backgroundColor: Color.fromARGB(255, 84, 132, 235),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Color.fromARGB(255, 84, 132, 235),
          ),
        ],
        currentIndex: 0,
        onTap: _onTapped,
      ),
      body: const WelcomeText(),
    );
  }
}

class WelcomeText extends StatefulWidget {
  const WelcomeText({Key? key}) : super(key: key);

  @override
  State<WelcomeText> createState() => _WelcomeTextState();
}

class _WelcomeTextState extends State<WelcomeText> {
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  late final Stream<QuerySnapshot> _userDataStream = FirebaseFirestore.instance
      .collection("users")
      .where("id", isEqualTo: _userId)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _userDataStream,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> userDataSnapshot) {
        List userDataList = userDataSnapshot.data!.docs;
        var userData = userDataList[0];

        if (userDataList.isEmpty) {
          return const Text("No Data");
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back, ${userData["username"]}.'),
            const Text("It's been _ days since you last logged in."),
            const Text("There are _ flashcards to study today."),
            const Text("There are _ flashcards in your collection."),
            Row(
              children: [
                button(context, "Tags", "Create", Icons.add, Colors.blue),
                button(context, "Tags", "Edit", Icons.edit, Colors.blue),
              ],
            ),
            Row(
              children: [
                button(context, "List", "Create", Icons.add, Colors.yellow),
                button(context, "List", "Edit", Icons.edit, Colors.yellow),
              ],
            ),
          ],
        );
      },
    );
  }
}

Container button(BuildContext context, String text, String stat, IconData icon,
    Color color) {
  return Container(
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
    width: 180,
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
              text,
              style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 138, 138, 138),
                  fontWeight: FontWeight.w500),
            ),
            Text(
              stat,
              style: const TextStyle(
                  color: Color.fromARGB(255, 95, 94, 94),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    ),
  );
}
