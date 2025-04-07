import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/AssetMapper.dart';

class CharacterContainer extends StatelessWidget {
  final User? user;

  const CharacterContainer({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const SizedBox.shrink(); // More efficient than SizedBox()
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        // Handle loading and error states more gracefully
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
        final coins = data['coins'] as int? ?? 0;

        return _buildCharacterUI(character, pet, coins);
      },
    );
  }

  Widget _buildCharacterUI(String character, String pet, int coins) {
    return Container(
      color: Colors.white.withOpacity(0.3),
      child: Column(
        children: [
          // Health Bar
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20),
            child: Row(
              children: const [
                Icon(Icons.favorite, color: Colors.red),
                SizedBox(width: 5),
                SizedBox(width: 80, height: 8, child: ColoredBox(color: Colors.red)),
              ],
            ),
          ),

          // Mana Bar
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20),
            child: Row(
              children: const [
                Icon(Icons.bolt, color: Colors.blue),
                SizedBox(width: 5),
                SizedBox(width: 80, height: 8, child: ColoredBox(color: Colors.blue)),
              ],
            ),
          ),

          // Character, Pet and Ground
          SizedBox(
            height: 180,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Character and Pet
                Positioned(
                  bottom: 0,
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
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.yellow,
                        size: 24,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        coins.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
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
  }
}