import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_app/screens/signin_screen.dart';
import 'package:flashcards_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: const SettingsList(),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
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
