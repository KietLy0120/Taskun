import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
    print("✔️ Firebase Initialized Successfully!");
    runApp(const MyApp());
  } catch (e) {
    print('🔥 Firebase Initialization Error: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskun',

      initialRoute: '/', // Set the initial route to login
      routes: {
        '/': (context) => LoginScreen(), // Login screen
        '/signup': (context) => SignupScreen(), // Signup screen
        '/home': (context) => HomeScreen(), // Home screen
        '/character-selection': (context) => CharacterSelectionScreen(), // Character selection screen
      },
    );
  }
}