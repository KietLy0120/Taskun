import 'package:flutter/material.dart';

class CharacterContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.2), // White background with 20% opacity
      child: Column(
        children: [
          // Health Bar
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20), // Reduced padding from top
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.red),
                SizedBox(width: 5),
                Container(width: 80, height: 8, color: Colors.red), // Smaller health bar
              ],
            ),
          ),

          // Mana Bar
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20),
            child: Row(
              children: [
                Icon(Icons.bolt, color: Colors.blue),
                SizedBox(width: 5),
                Container(width: 80, height: 8, color: Colors.blue), // Smaller mana bar
              ],
            ),
          ),

          // Character, Pet, and Coin with Ground using Stack
          Container(
            height: 180, // Increased height to fit the larger character and pet
            child: Stack(
              alignment: Alignment.bottomCenter, // Aligns everything at the bottom
              children: [
                // Ground image
                Positioned(
                  bottom: 0, // Place the ground image at the bottom
                  child: Container(
                    height: 60, // Ground height remains the same
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/icons/ground.png"), // Replace with your ground image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Character and Pet
                Positioned(
                  bottom: 0, // Position them on the ground
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Makes the Row as small as needed
                    children: [
                      Image.asset("assets/pets/dog.png", width: 60, height: 60), // Larger dog size
                      SizedBox(width: 10),
                      Image.asset("assets/characters/warrior.png", width: 90, height: 90), // Larger character size
                    ],
                  ),
                ),

                // Coin, positioned to the right
                Positioned(
                  bottom: 0, // Adjust coin to appear just above the ground
                  right: 20,
                  child: Row(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.yellow, size: 24), // Smaller coin icon
                      SizedBox(width: 5),
                      Text("599", style: TextStyle(fontSize: 20, color: Colors.white)), // Smaller font size
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
