import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_app/screens/manage_tags_screen.dart';
import 'package:flashcards_app/utils/screensize_reducer.dart';
import 'package:flashcards_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
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
  final Stream<QuerySnapshot> _userDataStream = FirebaseFirestore.instance
      .collection("users")
      .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  int? _totalFlashcards;

  @override
  void initState() {
    _getTotalFlashcards();
    super.initState();
  }

  void _getTotalFlashcards() {
    FirebaseFirestore.instance
        .collection('flashcards')
        .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      ((flashcards) {
        setState(() {
          _totalFlashcards = flashcards.docs.length;
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _userDataStream,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> userDataSnapshot) {
        if (userDataSnapshot.connectionState == ConnectionState.waiting) {
          return const Text("No Connection");
        } else if (userDataSnapshot.connectionState == ConnectionState.active ||
            userDataSnapshot.connectionState == ConnectionState.done) {
          if (userDataSnapshot.hasError) {
            return const Text('Error');
          } else if (userDataSnapshot.hasData) {
            if (userDataSnapshot.hasData) {
              List userDataList = userDataSnapshot.data!.docs.toList();
              var userData = userDataList[0];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome back, ${userData["username"]}.'),
                  const Text("There are _ flashcards to study today."),
                  Text(
                    'There are $_totalFlashcards flashcards in your collection.',
                  ),
                  GestureDetector(
                    child: button(
                        context, "Tags", "Manage", Icons.tag, Colors.blue),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageTagsScreen(),
                        ),
                      );
                    },
                  ),
                  button(context, "Lists", "Manage", Icons.list, Colors.yellow),
                ],
              );
            }
          } else {
            return const Text('Empty data');
          }
        } else {
          return Text('State: ${userDataSnapshot.connectionState}');
        }
        throw Error();
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
    width: screenWidth(context, reducedBy: 50),
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
