import 'package:firebase_core/firebase_core.dart';
import 'package:flashcards_app/firebase_options.dart';
import 'package:flashcards_app/screens/signin_screen.dart';
import 'package:flashcards_app/widgets/flashcard.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInScreen(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: Scaffold(
  //       backgroundColor: const Color.fromARGB(255, 228, 88, 88),
  //       appBar: AppBar(
  //         backgroundColor: Colors.transparent,
  //         shadowColor: Colors.transparent,
  //       ),
  //       body: const Flashcard(),
  //     ),
  //   );
  // }
}
