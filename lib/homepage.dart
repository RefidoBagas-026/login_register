import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final user=FirebaseAuth.instance.currentUser;
  signout()async{
    await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
        actions: [
          IconButton(
            icon: const Icon(Icons.login_rounded),
            onPressed: (() => signout()),
          ),
        ],
      ),
      body: Center(
        child: Text("${user!.email}"),
      ),

    );
  }
}
