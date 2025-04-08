import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/AssetMapper.dart';

class CharacterContainer extends StatelessWidget {
  final Map<String, String> characters = {
    "Warrior": "assets/characters/warrior.png",
    "Mage": "assets/characters/mage.png",
  };

  final Map<String, String> pets = {
    "Dog": "assets/pets/dog.png",
    "Cat": "assets/pets/cat.png",
  };

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
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
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 20),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red),
                    const SizedBox(width: 5),
                    Container(width: health.toDouble()/2, height: 8, color: Colors.red),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 20),
                child: Row(
                  children: [
                    Icon(Icons.bolt, color: Colors.blue),
                    SizedBox(width: 5),
                    Container(width: attack.toDouble()/2, height: 8, color: Colors.blue),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 20),
                child: Row(
                  children: [
                    Icon(Icons.stars_sharp, color: Colors.black),
                    SizedBox(width: 5),
                    Text(name, style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 145,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 60,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/icons/ground.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(AssetMapper.getPetAsset(pet), width: 60, height: 60),
                          SizedBox(width: 10),
                          Image.asset(AssetMapper.getCharacterAsset(character), width: 90, height: 90),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 20,
                      child: Row(
                        children: [
                          Icon(Icons.monetization_on, color: Colors.yellow, size: 24),
                          SizedBox(width: 5),
                          Text(coins.toString(), style: TextStyle(fontSize: 20, color: Colors.white)),
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
