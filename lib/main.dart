import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskun/screens/battle_screen.dart';
import 'firebase_options.dart';
import 'auth/login_screen.dart';
import 'auth/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/character_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase Initialization Error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskun',
      initialRoute: '/', // Set the initial route to login
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) =>  HomeScreen(),
        '/battle': (context) =>  BattleScreen(),
      },
    );
  }
}
