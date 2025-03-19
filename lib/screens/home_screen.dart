import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/add_button.dart';
import '../widgets/add_modal.dart';
import '../auth/login_screen.dart';
import '../navigation/navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/daily_container.dart'; // Your updated DailyContainer widget
import '../widgets/character_container.dart'; // Import CharacterContainer

class HomeScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  HomeScreen({super.key});

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
                "assets/backgrounds/home-bg.png",
                fit: BoxFit.cover
            ),
          ),

          // Main content
          Column(
            children: [
              // CharacterContainer takes up 1/3 of the screen height
              Container(
                height: MediaQuery.of(context).size.height / 3,  // 1/3 of the screen height
                child: CharacterContainer(),
              ),

              // Expanded DailyContainer takes up the remaining space
              Expanded(
                child: DailyContainer(user: user), // Your task container
              ),

              // CustomAddButton at the bottom-right
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CustomAddButton(
                    onPressed: () => AddModal.show(context),
                  ),
                ),
              ),

              // CustomBottomNavBar at the bottom
              CustomBottomNavBar(selectedIndex: 0, onItemTapped: (index) {}),
            ],
          ),
        ],
      ),
    );
  }
}
