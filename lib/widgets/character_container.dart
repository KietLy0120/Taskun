import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CharacterContainer extends StatefulWidget {
  final User? user;

  const CharacterContainer({Key? key, required this.user}) : super(key: key);

  @override
  _CharacterContainerState createState() => _CharacterContainerState();
}

class _CharacterContainerState extends State<CharacterContainer> {
  late int coins;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (widget.user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          coins = userDoc['coins'] ?? 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.3), // White background with 20% opacity
      child: Column(
        children: [
          // Health Bar
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20),
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.red),
                SizedBox(width: 5),
                Container(width: 80, height: 8, color: Colors.red),
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
                Container(width: 80, height: 8, color: Colors.blue),
              ],
            ),
          ),

          // Character, Pet, and Coin with Ground using Stack
          Container(
            height: 180, // Increased height to fit the larger character and pet
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Ground image
                Positioned(
                  bottom: 0, // Place the ground image at the bottom
                  child: Container(
                    height: 60, // Ground height remains the same
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/icons/ground.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Character and Pet
                Positioned(
                  bottom: 0, // Position them on the ground
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/pets/dog.png", width: 60, height: 60),
                      SizedBox(width: 10),
                      Image.asset("assets/characters/warrior.png", width: 90, height: 90),
                    ],
                  ),
                ),

                // Coin, positioned to the right
                Positioned(
                  bottom: 0, // Adjust coin to appear just above the ground
                  right: 20,
                  child: Row(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.yellow, size: 24),
                      SizedBox(width: 5),
                      Text("$coins", style: TextStyle(fontSize: 20, color: Colors.white)),
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