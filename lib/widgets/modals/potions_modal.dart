import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helpers/AssetMapper.dart';

void showPotionsPopup(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  final potionsSnapshot = await FirebaseFirestore.instance
      .collection('items')
      .where('type', isEqualTo: 'potion')
      .get();

  final allPotions = potionsSnapshot.docs
      .map((doc) => doc.data())
      .toList();




  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (context, setState) {

            //Helper method for building 'Equipped' columns
            Widget buildItemColumn(Map<String, dynamic>? itemData, String label) {
              final String potionName = itemData?['name']?.toString().toLowerCase() ?? '';
              final int price = AssetMapper.potionPrices[potionName] ?? 0;
              return Container(
                decoration: BoxDecoration(
                  color: Colors.brown.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(label,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 8),

                    // Item Icon or Cancel
                    itemData != null && itemData['imagePath'] != null
                        ? Image.asset(
                      itemData['imagePath'],
                      width: 80,
                      height: 80,
                    )
                        : const Icon(Icons.cancel, color: Colors.white, size: 50),
                    const SizedBox(height: 6),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            //name
                            Text(
                              itemData?['name'] ?? 'None',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            // Description
                            Text(
                              itemData?['description'] ?? '',
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),

                            // Health Bonus
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'HP +${itemData?['healthBonus'] ?? 0}',
                                  style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 16),
                                ),
                                const SizedBox(width: 10),
                                // Attack Bonus
                                Text(
                                  'ATK +${itemData?['attackBonus'] ?? 0}',
                                  style: const TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 10)
                              ],
                            ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700]
                              ),
                              onPressed: () async {
                                await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                                  // TODO: Handle buy action
                                }, SetOptions(merge: true));

                                Navigator.of(context).pop(); // close the modal
                              },
                              child:
                               SizedBox(
                                width: 120,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 5),
                                    const Text(
                                        "Buy for ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '$price',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon (Icons.monetization_on,
                                        color: Colors.yellow[600], size: 24),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 5)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Dialog(
              backgroundColor: Colors.brown.shade900.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.6,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Potions",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 24),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      height: 280,
                      child: PageView(
                        children:
                        allPotions.map((itemData) => buildItemColumn(itemData, itemData['name'])).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // close the modal
                      },
                      child:
                      const Text("Back"),
                    ),
                  ],
                ),
              ),
            );
          }
      );
    },
  );
}