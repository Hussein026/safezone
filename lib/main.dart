import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/bloc/auth/auth_bloc.dart';
import 'package:safezone/bloc/auth/auth_event.dart';
import 'package:safezone/bloc/incident/incident_bloc.dart';
import 'package:safezone/bloc/notification/notification_bloc.dart';
import 'package:safezone/bloc/sos/sos_bloc.dart';
import 'package:safezone/core/services/firebase_service.dart';
import 'package:safezone/core/services/hive_service.dart';
import 'package:safezone/core/theme/app_theme.dart';
import 'package:safezone/presentation/screens/admin/admin_screen.dart';
import 'package:safezone/presentation/screens/auth/forgot_password_screen.dart';
import 'package:safezone/presentation/screens/auth/login_screen.dart';
import 'package:safezone/presentation/screens/auth/register_screen.dart';
import 'package:safezone/presentation/screens/community/community_screen.dart';
import 'package:safezone/presentation/screens/feed/feed_screen.dart';
import 'package:safezone/presentation/screens/home/home_screen.dart';
import 'package:safezone/presentation/screens/notifications/notifications_screen.dart';
import 'package:safezone/presentation/screens/profile_setup/profile_setup_screen.dart';
import 'package:safezone/presentation/screens/settings/settings_screen.dart';
import 'package:safezone/presentation/screens/sos/sos_screen.dart';
import 'package:safezone/presentation/screens/splash/splash_screen.dart';
import 'package:safezone/presentation/screens/incident/report_incident_screen.dart';
import 'package:safezone/presentation/screens/incident/incident_detail_screen.dart';
import 'package:safezone/presentation/screens/analytics/analytics_screen.dart';


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
    final firebaseService = FirebaseService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(firebaseService: firebaseService)
            ..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (_) => IncidentBloc(firebaseService: firebaseService),
        ),
        BlocProvider(
          create: (_) => NotificationBloc(firebaseService: firebaseService),
        ),
        BlocProvider(
          create: (_) => SosBloc(firebaseService: firebaseService),
        ),
      ],
      child: MaterialApp(
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
          '/profile-setup': (context) => const ProfileSetupScreen(),
          '/home': (context) => HomeScreen(),
          '/sos': (context) => const SosScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/admin': (context) => const AdminScreen(),
          '/feed': (context) => const FeedScreen(),
          '/notifications': (context) => const NotificationsScreen(),
          '/community': (context) => const CommunityScreen(),
          '/report-incident': (context) => const ReportIncidentScreen(),
          '/incident-detail': (context) => const IncidentDetailScreen(),
          '/analytics': (context) => const AnalyticsScreen(),
        },
      ),
    );
  }
}

