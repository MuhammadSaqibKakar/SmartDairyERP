import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isEnglish = true;

  void toggleLanguage() => setState(() => isEnglish = !isEnglish);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartDairyERP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: LoginScreen(
        isEnglish: isEnglish,
        toggleLanguage: toggleLanguage,
      ),
    );
  }
}
