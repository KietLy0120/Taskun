import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../helpers/AssetMapper.dart';
import '../../helpers/handleBuyItem.dart';

// widgets/modals/armor_modal.dart
void showArmorPopup(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final armorSnapshot = await FirebaseFirestore.instance
      .collection('items')
      .where('type', isEqualTo: 'armor')
      .get();

  final allArmor = armorSnapshot.docs
      .map((doc) => {...doc.data() as Map<String, dynamic>, 'docId': doc.id})
      .toList();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Widget buildItemColumn(Map<String, dynamic> itemData) {
            final String docId = itemData['docId'] ?? '';
            final int price = itemData['price'] ?? 0;
            final String name = itemData['name'] ?? 'Armor';

            return Container(
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Image.asset(itemData['imagePath'], width: 80, height: 80),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                    onPressed: () => handleBuyItem(context, 'armor', docId, price),
                    child: Text("Buy for $price coins"),
                  )
                ],
              ),
            );
          }

          return Dialog(
            backgroundColor: Colors.brown.shade900.withOpacity(0.8),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  const Text("Armor", style: TextStyle(color: Colors.white, fontSize: 24)),
                  Expanded(
                    child: PageView(
                      children: allArmor.map((item) => buildItemColumn(item)).toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Back"),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

