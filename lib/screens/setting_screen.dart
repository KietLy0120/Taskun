import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskun/widgets/charsetting_container.dart';
import '../navigation/navigation_bar.dart';

import '../widgets/stat_container.dart';

class SettingScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
                "assets/backgrounds/background2.gif",
                fit: BoxFit.cover
            ),
          ),

          // Main content
          Column(
            children: [
              // CharacterContainer takes up 1/3 of the screen height

              Container(
                height: MediaQuery.of(context).size.height / 2.5,  // 1/3 of the screen height
                child: CharSettingContainer(user: user),
              ),
              Expanded(
                child: StatContainer(user: user), // Your task container
              ),

              // CustomBottomNavBar at the bottom
              CustomBottomNavBar(selectedIndex: 4, onItemTapped: (index) {}),
            ],
          ),
        ],
      ),
    );
  }
}
