import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_app/screens/create_screen.dart';
import 'package:flashcards_app/screens/signin_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    builder: ((context) => CreateFlashcardScreen()),
                  ),
                );
              },
              child: const Text("Add Flashcard"))
        ],
      ),
    );
  }
}
