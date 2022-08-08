import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  late final Stream<QuerySnapshot> _userDataStream = FirebaseFirestore.instance
      .collection("users")
      .where("id", isEqualTo: _userId)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _userDataStream,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> userDataSnapshot) {
        List userDataList = userDataSnapshot.data!.docs.toList();
        var userData = userDataList[0];

        if (userDataList.isEmpty) {
          return const Text("No Data");
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back, ${userData["username"]}.'),
            const Text("It's been _ days since you last logged in."),
            const Text("There are _ flashcards to study today."),
            Text(
              'There are ${userData["total_flashcards"]} flashcards in your collection.',
            ),
            button(context, "Tags", "Manage", Icons.tag, Colors.blue),
            button(context, "Lists", "Manage", Icons.list, Colors.yellow),
          ],
        );
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
