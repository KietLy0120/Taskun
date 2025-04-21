import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskun/helpers/ButtonAnimator.dart';
import 'package:taskun/screens/shop_inside_screen.dart';
import '../navigation/navigation_bar.dart';
import '../helpers/AssetMapper.dart';
import '../widgets/modals/inventory_modal.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

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
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/shop_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Main content
          FutureBuilder<Map<String, dynamic>?>(
            future: fetchUserData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!;
              final characterType = data['character'] ?? '';
              final petType = data['pet'] ?? '';

              return Transform.translate(
                offset: const Offset(0, -35),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 315),

                      //Characters
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Pet Icon
                            Image.asset(
                              AssetMapper.getPetAsset(petType),
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(width: 10),

                            // Character Icon
                            Image.asset(
                              AssetMapper.getCharacterAsset(characterType),
                              width: 70,
                              height: 70,
                            ),
                            const SizedBox(width: 50),

                            // Shopkeeper Icon
                            Transform.translate(
                              offset: const Offset(0, -20),
                              child: Image.asset(
                                'assets/characters/misc_character_icons/shop_owner.png',
                                width: 160,
                                height: 110,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),

                      //Buttons
                      Column(
                        children: [
                          ButtonAnimator(
                            imagePath: 'assets/buttons/browse_button.png',
                            width: 259,
                            height: 89,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ShopInsideScreen(),
                                )
                              );
                            }
                          ),
                          const SizedBox(height: 15),

                          ButtonAnimator(
                              imagePath: 'assets/buttons/inventory_button.png',
                              width: 259,
                              height: 89,
                              onTap: () => showInventoryPopup(context)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 3,
        onItemTapped: (index) {
          // Handle navigation here if needed
        },
      ),
    );
  }
}
