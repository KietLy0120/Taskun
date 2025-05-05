import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../auth/login_screen.dart';
import '../helpers/AssetMapper.dart';

class CharSettingContainer extends StatelessWidget {
  final User? user;

  static const Map<String, String> characters = {
    "Warrior": "assets/characters/warrior.png",
    "Mage": "assets/characters/mage.png",
  };

  static const Map<String, String> pets = {
    "Dog": "assets/pets/dog.png",
    "Cat": "assets/pets/cat.png",
  };

  const CharSettingContainer({Key? key, required this.user}) : super(key: key);

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
        final Timestamp timestamp = data['createdAt'];
        final DateTime dateTime = timestamp.toDate();
        final String formattedDate = DateFormat('MMMM d, y').format(dateTime);
        final int level = (data['level'] as num?)?.toInt() ?? 1;
        final int experience = (data['experience'] as num?)?.toInt() ?? 0;

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Logout button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Logout"),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Character and Pet images
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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

                const SizedBox(height: 10),

                // Stats box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.favorite, color: Colors.red),
                                const SizedBox(width: 5),
                                Container(
                                  width: health.toDouble() / 2,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'HP: $health',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.bolt, color: Colors.blue),
                                const SizedBox(width: 5),
                                Container(
                                  width: attack.toDouble() / 2,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'ATK: $attack',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.explicit_outlined, color: Colors.green),
                                const SizedBox(width: 5),
                                Text(
                                  '$experience/${_getNextLevelXP(level)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Level: $level',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.stars_sharp, color: Colors.white),
                                const SizedBox(width: 5),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.monetization_on, color: Colors.yellow, size: 20),
                                const SizedBox(width: 5),
                                Text(
                                  coins.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'User since: $formattedDate',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
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
