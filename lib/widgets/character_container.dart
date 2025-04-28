import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/AssetMapper.dart';

class CharacterContainer extends StatelessWidget {
  final User? user;
  static const Map<String, String> characters = {
    "Warrior": "assets/characters/warrior.png",
    "Mage": "assets/characters/mage.png",
  };

  static const Map<String, String> pets = {
    "Dog": "assets/pets/dog.png",
    "Cat": "assets/pets/cat.png",
  };

  const CharacterContainer({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('User data not found'));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final character = data['character'] as String? ?? 'Warrior';
        final pet = data['pet'] as String? ?? 'Dog';
        final String name = data['name'] ?? 'Player';
        final int coins = data['coins'] ?? 0;
        final int health = data['health'] ?? 0;
        final int attack = data['attack'] ?? 0;

        return Container(
          color: Colors.white.withOpacity(0.3),
          child: Column(
            children: [
              // Health Bar
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 20),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red),
                    const SizedBox(width: 5),
                    Container(
                      width: health.toDouble() / 2,
                      height: 8,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),

              // Attack Bar
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 20),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.blue),
                    const SizedBox(width: 5),
                    Container(
                      width: attack.toDouble() / 2,
                      height: 8,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),

              // Player Name
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 20),
                child: Row(
                  children: [
                    const Icon(Icons.stars_sharp, color: Colors.black),
                    const SizedBox(width: 5),
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Character and Pet
              SizedBox(
                height: 120,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Character and Pet
                    Positioned(
                      bottom: 10,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AssetMapper.getPetAsset(pet),
                            width: 60,
                            height: 60,
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            AssetMapper.getCharacterAsset(character),
                            width: 90,
                            height: 90,
                          ),
                        ],
                      ),
                    ),

                    // Coins
                    Positioned(
                      bottom: 0,
                      right: 20,
                      child: Row(
                        children: [
                          const Icon(Icons.monetization_on,
                              color: Colors.yellow, size: 24),
                          const SizedBox(width: 5),
                          Text(
                            coins.toString(),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
