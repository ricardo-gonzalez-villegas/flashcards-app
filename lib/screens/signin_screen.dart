import 'package:flashcards_app/widgets/reuseable_widgets.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            reusableTextField(
                "Enter Username", Icons.person, false, _emailController),
            reusableTextField(
                "Enter Password", Icons.lock, true, _passwordController)
          ],
        ),
      ),
    );
  }
}
