import 'package:flutter/material.dart';
import 'navigation_bar.dart';

class BattleScreen extends StatelessWidget {
  BattleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // This allows the background to extend behind the navbar
      body: Stack(
        children: [
          // Background image covering the entire screen, including behind the navbar
          Positioned.fill(
            child: Image.asset(
              'assets/background2.gif', // Replace with your asset path
              fit: BoxFit.cover,
            ),
          ),
          // Main content placed on top of the background
          Center(
            child: Text(
              'Battle Screen',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      // Custom bottom navigation bar
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1, // Update with proper state management if needed
        onItemTapped: (index) {
          // Handle navigation based on index
        },
      ),
    );
  }
}