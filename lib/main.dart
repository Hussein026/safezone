import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:safezone/core/services/hive_service.dart';
import 'package:safezone/core/theme/app_theme.dart';
import 'package:safezone/presentation/screens/auth/forgot_password_screen.dart';
import 'package:safezone/presentation/screens/auth/login_screen.dart';
import 'package:safezone/presentation/screens/auth/register_screen.dart';
import 'package:safezone/presentation/screens/splash/splash_screen.dart';

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
  await HiveService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeZone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const Scaffold(
              body: Center(child: Text('Home - Coming Soon')),
            ),
      },
    );
  }
}