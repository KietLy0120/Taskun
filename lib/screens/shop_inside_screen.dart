import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskun/widgets/modals/armor_modal.dart';
import 'package:taskun/widgets/modals/potions_modal.dart';
import 'package:taskun/widgets/modals/weapons_modal.dart';
import '../helpers/AssetMapper.dart';
import '../helpers/ButtonAnimator.dart';

class ShopInsideScreen extends StatelessWidget {
  const ShopInsideScreen({super.key});

  Future<Map<String, dynamic>?> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return doc.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchUserData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final character = data['character'] ?? 'Warrior';
        final pet = data['pet'] ?? 'Dog';
        final int coins = data['coins'] ?? 0;

        return Stack(
          children: [
            // Background
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounds/shop_inside_background.png',
                fit: BoxFit.cover,
              ),
            ),

            // Back Button
            Positioned(
              top: 170,
              left: 150,
              child: ButtonAnimator(
                imagePath: 'assets/buttons/leave_button.png',
                width: 100,
                height: 40,
                onTap: () => Navigator.pop(context),
              ),
            ),

            // Potions modal
            Positioned(
              top: 410,
              right: 90,
              child: ButtonAnimator(
                imagePath: 'assets/buttons/browse_button.png',
                width: 170,
                height: 50,
                onTap: () => showPotionsPopup(context)
              ),
            ),

            // Character (bottom-left)
            Positioned(
              left: 5,
              bottom: 290,
              child: Column(
                children: [
                  Row(
                    children: [
                      Positioned(
                        bottom: 330,
                        left: 80,
                        child: Image.asset(
                          AssetMapper.getCharacterAsset(character),
                          width: 70,
                          height: 70,
                        ),
                      ),
                      const SizedBox(width: 5),
                      // Pet (next to character)
                      Positioned(
                        bottom: 330,
                        left: 20,
                        child: Image.asset(
                        AssetMapper.getPetAsset(pet),
                        width: 50,
                        height: 50,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
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

            // Armor modal
            Positioned(
              bottom: 240,
              right: 120,
              child: ButtonAnimator(
                imagePath: 'assets/buttons/browse_armor_button.png',
                width: 170,
                height: 50,
                onTap: () => showArmorPopup(context)
              ),
            ),

            // Weapon modal
            Positioned(
              bottom: 40,
              right: 10,
              child: ButtonAnimator(
                imagePath: 'assets/buttons/browse_weapons_button.png',
                width: 160,
                height: 50,
                onTap: () => showWeaponsPopup(context)
              ),
            ),
          ],
        );
      },
    );
  }
}
