import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final bool isEnglish;
  const HomeScreen({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final idText = user?.email ?? user?.phoneNumber ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEnglish ? 'Home' : 'ہوم'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) Navigator.popUntil(context, (route) => route.isFirst);
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          isEnglish ? 'Welcome\n$idText' : 'خوش آمدید\n$idText',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
