import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'firebase_options.dart';
import 'login_screen.dart'; // Import the LoginScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
runApp(const MyApp());
=======
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
>>>>>>> Stashed changes
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskun',
<<<<<<< Updated upstream
      home: LoginScreen(), // Set LoginScreen as the home screen
=======
      initialRoute: '/', // Set the initial route to login
      routes: {
        '/': (context) => LoginScreen(), // Login screen
        '/signup': (context) => SignupScreen(), // Signup screen
        '/home': (context) => HomeScreen(), // Home screen
        '/character-selection': (context) => CharacterSelectionScreen(), // Character selection screen
      },
>>>>>>> Stashed changes
    );
  }
}