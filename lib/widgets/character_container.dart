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
        final int coins = (data['coins'] as num?)?.toInt() ?? 0;

        // Base stats
        final int baseHealth = (data['health'] as num?)?.toInt() ?? 100;
        final int baseAttack = (data['attack'] as num?)?.toInt() ?? 0;

        // Equipment bonuses
        final int healthBonus = (data['equipmentHealthBonus'] as num?)?.toInt() ?? 0;
        final int attackBonus = (data['equipmentAttackBonus'] as num?)?.toInt() ?? 0;

        // Total stats
        final int totalHealth = baseHealth + healthBonus;
        final int totalAttack = baseAttack + attackBonus;

        final int level = (data['level'] as num?)?.toInt() ?? 1;
        final int experience = (data['experience'] as num?)?.toInt() ?? 0;

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (DateTime.now().hour >= 7 && DateTime.now().hour < 19)
                  ? Colors.white.withOpacity(0.3)
                  : Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // XP Progress Bar and Level
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[800]?.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Level $level',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$experience/${_getNextLevelXP(level)} XP',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: experience / _getNextLevelXP(level),
                            backgroundColor: Colors.grey[600],
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Stats Container (blue)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade500,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Health Bar with bonus indicator
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.favorite, color: Colors.red, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$totalHealth',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  if (healthBonus > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(
                                        '(+$healthBonus)',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Container(
                                width: totalHealth.toDouble() / 2,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Attack Bar with bonus indicator
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.bolt, color: Colors.blue, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$totalAttack',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  if (attackBonus > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(
                                        '(+$attackBonus)',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Container(
                                width: totalAttack.toDouble() / 2,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Player Name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.stars_sharp, color: Colors.white),
                              const SizedBox(width: 5),
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                // Character and Pet
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AssetMapper.getPetAsset(pet),
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(width: 10),
                              Image.asset(
                                AssetMapper.getCharacterAsset(character),
                                width: 90,
                                height: 90,
                              ),
                            ],
                          )
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, right: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade500,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.monetization_on, color: Colors.yellow, size: 24),
                                const SizedBox(width: 5),
                                Text(
                                  coins.toString(),
                                  style: const TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _getNextLevelXP(int level) {
    const thresholds = {1: 50, 2: 100, 3: 200, 4: 350};
    return thresholds[level] ?? 500;
  }
}