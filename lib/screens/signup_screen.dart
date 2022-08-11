import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_app/screens/home_screen.dart';
import 'package:flashcards_app/widgets/reuseable_widgets.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection("users");
  Timestamp timeStamp = Timestamp.fromDate(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Return'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          reusableTextField(
              "Enter Username", Icons.person, false, _usernameController),
          reusableTextField(
              "Enter Email", Icons.email, false, _emailController),
          reusableTextField(
              "Enter Password", Icons.lock, true, _passwordController),
          signInSignUpButton(
            context,
            false,
            () {
              FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text)
                  .then(
                (value) {
                  _usersCollection.add({
                    "id": value.user?.uid,
                    "username": _usernameController.text,
                    "created_at": timeStamp,
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
              );
            },
          )
        ]),
      ),
    );
  }
}
