import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBkaot0YHfzV_oWZI4jDUl8Q4uTsp9jtiE",
      authDomain: "safezone-b5564.firebaseapp.com",
      projectId: "safezone-b5564",
      storageBucket: "safezone-b5564.firebasestorage.app",
      messagingSenderId: "62842983000",
      appId: "1:62842983000:web:b753cad750889c4fc9f02d",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeZone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            '🛡️ SafeZone',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}