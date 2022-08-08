import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_app/screens/home_screen.dart';
import 'package:flashcards_app/screens/signup_screen.dart';
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
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String userId = FirebaseAuth.instance.currentUser!.uid;
  late DocumentReference userDocument = users.doc(documentId);
  Timestamp timeStamp = Timestamp.fromDate(DateTime.now());
  String? documentId;

  @override
  void initState() {
    _getDocumentId(users, userId);
    super.initState();
  }

  void _updateSignedInTime() {
    userDocument.update({'signed_in': timeStamp});
  }

  void _getDocumentId(CollectionReference users, String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .where("id", isEqualTo: userId)
        .get()
        .then(
          (QuerySnapshot snapshot) => {_setDocumentId(snapshot.docs[0].id)},
        );
  }

  void _setDocumentId(String id) {
    setState(() {
      documentId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          reusableTextField(
              "Enter Username", Icons.person, false, _emailController),
          reusableTextField(
              "Enter Password", Icons.lock, true, _passwordController),
          signInSignUpButton(context, true, () {
            FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text)
                .then((value) {
              _updateSignedInTime();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }).onError((error, stackTrace) {
              print("Error ${error.toString()}");
            });
          }),
          signUpOption(context),
        ],
      ),
    );
  }
}

Row signUpOption(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('Dont have an account? '),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignUpScreen()),
          );
        },
        child: const Text(
          'Sign Up',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}
