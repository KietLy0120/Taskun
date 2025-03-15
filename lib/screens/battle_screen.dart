import 'package:flutter/material.dart';
import '../navigation/navigation_bar.dart';

class BattleScreen extends StatelessWidget {
  const BattleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // This allows the background to extend behind the navbar
      body: Stack(
        children: [
          // Background image covering the entire screen, including behind the navbar
          Positioned.fill(
            child: Image.asset(
              'assets/battle_backgrounds/battle_background.png', // Replace with your asset path
              fit: BoxFit.cover,
            ),
          ),
          // Main content placed on top of the background
          //Floating Action Button
          Positioned(
            bottom: 110,
            right: 20,
            child: FloatingActionButton(
                onPressed: () => _showBattlePopup(context),
              backgroundColor: Colors.indigo.withOpacity(0.6),
              child: Image.asset(
                'assets/icons/treasure_bronze_open.png',
                width: 50,
                height: 50,
              )
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //CHANGE TO USER'S CHARACTER
                    Image.asset(
                      'assets/icons/character_kishi_man_01_blue_black.png',
                      width: 70, height: 70,
                    ),
                    SizedBox(width: 180),
                    //CHANGE TO SELECTED ENEMY
                    Image.asset(
                      'assets/icons/character_madoshi_01_purple (1).png',
                      width: 70, height: 70,
                    ),
                  ],
                ),
              ],
            ),
          )
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

  void _showBattlePopup(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.indigo.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Battle Options',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      //add battle action
                    },
                    child: const Text(
                        "Start Battle"
                    ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                ),
              ]
            )
          )
        );
      }
    );
  }
}