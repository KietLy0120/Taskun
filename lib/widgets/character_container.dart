import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/AssetMapper.dart';

class CharacterContainer extends StatelessWidget {
  final User? user;

  const CharacterContainer({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) return const SizedBox.shrink();

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
        final name = data['name'] as String? ?? 'Player';
        final coins = data['coins'] as int? ?? 0;
        final health = data['health'] as int? ?? 0;
        final attack = data['attack'] as int? ?? 0;
        final level = data['level'] as int? ?? 1;
        final experience = data['experience'] as int? ?? 0;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Health Bar
                    _buildStatBar(
                      icon: Icons.favorite,
                      color: Colors.red,
                      value: health,
                      label: 'HP',
                    ),
                    const SizedBox(height: 8),

                    // Attack Bar
                    _buildStatBar(
                      icon: Icons.bolt,
                      color: Colors.blue,
                      value: attack,
                      label: 'ATK',
                    ),
                    const SizedBox(height: 12),

                    // Player Name
                    Row(
                      children: [
                        const Icon(Icons.stars_sharp, color: Colors.black),
                        const SizedBox(width: 8),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // XP Progress Bar
              XPProgressBar(
                level: level,
                experience: experience,
              ),

              // Character and Pet Display
              SizedBox(
                height: 150,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Character and Pet Images
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
                          const SizedBox(width: 16),
                          Image.asset(
                            AssetMapper.getCharacterAsset(character),
                            width: 90,
                            height: 90,
                          ),
                        ],
                      ),
                    ),

                    // Coins Display
                    Positioned(
                      bottom: 0,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.monetization_on,
                              color: Colors.yellow,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              coins.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildStatBar({
    required IconData icon,
    required Color color,
    required int value,
    required String label,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                height: 6,
                width: value.toDouble(),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class XPProgressBar extends StatelessWidget {
  final int level;
  final int experience;

  const XPProgressBar({
    Key? key,
    required this.level,
    required this.experience,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelThresholds = {
      1: 50,
      2: 100,
      3: 200,
      4: 350,
    };

    final nextThreshold = levelThresholds[level] ?? 100;
    final progress = nextThreshold > 0 ? experience / nextThreshold : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level $level',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$experience/$nextThreshold XP',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 8,
                width: MediaQuery.of(context).size.width * progress,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}