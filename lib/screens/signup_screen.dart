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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Return'),
      ),
      body: Container(
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
                  print("Sucessfully Created");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
              ).onError((error, stackTrace) {
                print("Error ${error.toString()}");
              });
            },
          )
        ]),
      ),
    );
  }
}
