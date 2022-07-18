import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_app/screens/user_collection_screen.dart';
import 'package:flashcards_app/screens/create_screen.dart';
import 'package:flashcards_app/screens/signin_screen.dart';
import 'package:flutter/material.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then(
                (value) {
                  print("Signed Out");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const SignInScreen()),
                    ),
                  );
                },
              );
            },
            child: const Text('Sign Out'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const CreateFlashcardScreen()),
                ),
              );
            },
            child: const Text("Add Flashcard"),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserCollectionScreen()),
                );
              },
              child: const Text("View Collection"))
        ],
      ),
    );
  }
}
