import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_app/screens/signin_screen.dart';
import 'package:flashcards_app/screens/user_collection_screen.dart';
import 'package:flutter/material.dart';

import 'create_screen.dart';
import 'home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
      body: const SettingsList(),
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
        currentIndex: 4,
        onTap: _onTapped,
      ),
    );
  }
}

class SettingsList extends StatelessWidget {
  const SettingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        GestureDetector(
          onTap: () => FirebaseAuth.instance.signOut().then(
            (value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const SignInScreen()),
                ),
              );
            },
          ),
          child: const ListTile(
            title: Center(child: Text("Log Out")),
            tileColor: Color.fromARGB(255, 226, 229, 231),
          ),
        )
      ],
    );
  }
}
