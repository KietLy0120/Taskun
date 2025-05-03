import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../helpers/AssetMapper.dart';

void showInventoryPopup(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  final userData = userDoc.data() ?? {};
  final inventoryData = userData['inventory'] ?? {};

  final List<String> ownedWeapons = List<String>.from(inventoryData['weapons'] ?? []);
  final List<String> ownedArmor = List<String>.from(inventoryData['armor'] ?? []);
  final List<String> ownedPotions = List<String>.from(inventoryData['potions'] ?? []);

  Future<List<Map<String, dynamic>>> fetchItemsByType(String type, List<String> ownedNames) async {
    if (ownedNames.isEmpty) return [];

    final futures = ownedNames.map((name) {
      String? docId;

      if (type == 'weapon') {
        docId = AssetMapper.weaponIds[name];
      } else if (type == 'armor') {
        docId = AssetMapper.armorIds[name];
      } else if (type == 'potion') {
        docId = AssetMapper.potionIds[name];
      }

      if (docId == null || docId.isEmpty) {
        return Future.value(null); // skip invalid ones
      }

      return FirebaseFirestore.instance.collection('items').doc(docId).get();
    }).toList();

    final snapshots = await Future.wait(futures);

    return snapshots
        .where((doc) => doc != null && doc.exists)
        .map((doc) => doc!.data() as Map<String, dynamic>)
        .toList();
  }



  String? weaponKey = userData['weapon'];
  String? armorKey = userData['armor'];
  String? potionKey = userData['potion'];

  String? selectedWeapon = weaponKey;
  String? selectedArmor = armorKey;
  String? selectedPotion = potionKey;

  List<Map<String, dynamic>> weaponInventory = await fetchItemsByType('weapon', ownedWeapons);
  List<Map<String, dynamic>> armorInventory = await fetchItemsByType('armor', ownedArmor);
  List<Map<String, dynamic>> potionInventory = await fetchItemsByType('potion', ownedPotions);


  Future<Map<String, dynamic>?> fetchItem(String? id) async {
    if (id == null || id.isEmpty) return null;

    String? docId = AssetMapper.weaponIds[id] ??
                    AssetMapper.armorIds[id] ??
                    AssetMapper.potionIds[id];

    if (docId == null || docId.isEmpty) return null;

    final doc = await FirebaseFirestore.instance
      .collection('items')
      .doc(AssetMapper.weaponIds[id] ?? AssetMapper.armorIds[id] ?? AssetMapper.potionIds[id] ?? '')
      .get();
    return doc.data();
  }

  final weapon = await fetchItem(weaponKey);
  final armor = await fetchItem(armorKey);
  final potion = await fetchItem(potionKey);

  Map<String, dynamic>? equippedWeaponData = weapon;
  Map<String, dynamic>? equippedArmorData = armor;
  Map<String, dynamic>? equippedPotionData = potion;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {

          //Helper method for building 'Equipped' columns
          Widget buildEquippedColumn(Map<String, dynamic>? itemData, String label) {
            final String itemName = itemData?['name'] ?? 'None';
            final String description = itemData?['description'] ?? '';
            final String imagePath = itemData?['imagePath'] ?? '';
            final int healthBonus = itemData?['healthBonus'] ?? 0;
            final int attackBonus = itemData?['attackBonus'] ?? 0;

            return Container(
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Item Icon or Cancel
                  imagePath.isNotEmpty
                      ? Image.asset(imagePath, width: 80, height: 80)
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
                          Text(
                            itemName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'HP +$healthBonus',
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'ATK +$attackBonus',
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios_rounded, color: Colors.brown, size: 25),
                        Spacer(),
                        Text("Swipe", style: TextStyle(color: Colors.brown, fontSize: 12)),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded, color: Colors.brown, size: 25),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }


          //Helper method for building inventory rows
          Widget buildInventoryRow(
              List<Map<String, dynamic>> inventory,
              String type,
              ) {
            // Determine which item is selected
            String? selectedId;
            if (type == 'weapon') selectedId = selectedWeapon;
            if (type == 'armor') selectedId = selectedArmor;
            if (type == 'potion') selectedId = selectedPotion;

            return SizedBox(
              height: 60,
              child: inventory.isEmpty
                  ? const Center(
                child: Icon(Icons.cancel, color: Colors.white, size: 40),
              )
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: inventory.length,
                itemBuilder: (context, index) {
                  final item = inventory[index];
                  final itemId = item['name'].toString();

                  final isSelected = selectedId == itemId;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle selection: deselect if already selected
                        if (type == 'weapon') {
                          if (selectedWeapon == itemId) {
                            selectedWeapon = null;
                            equippedWeaponData = null;
                          } else {
                            selectedWeapon = itemId;
                            equippedWeaponData = item;
                          }
                        } else if (type == 'armor') {
                          if (selectedArmor == itemId) {
                            selectedArmor = null;
                            equippedArmorData = null;
                          } else {
                            selectedArmor = itemId;
                            equippedArmorData = item;
                          }
                        } else if (type == 'potion') {
                          if (selectedPotion == itemId) {
                            selectedPotion = null;
                            equippedPotionData = null;
                          } else {
                            selectedPotion = itemId;
                            equippedPotionData = item;
                          }
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: isSelected
                            ? Border.all(color: Colors.yellowAccent, width: 3)
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        item['imagePath'],
                        width: 50,
                        height: 50,
                      ),
                    ),
                  );
                },
              ),
            );
          }


          return Dialog(
            backgroundColor: Colors.brown.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.9,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Inventory",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 265,
                    child: PageView(
                      children: [
                        buildEquippedColumn(equippedWeaponData, "Weapon"),
                        buildEquippedColumn(equippedArmorData, "Armor"),
                        buildEquippedColumn(equippedPotionData, "Potion"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text("Weapons", style: TextStyle(
                    fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold
                  ),),
                  buildInventoryRow(weaponInventory, 'weapon'),
                  const Text("Armor", style: TextStyle(
                      fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold
                  ),),
                  buildInventoryRow(armorInventory, 'armor'),
                  const Text("Potions", style: TextStyle(
                      fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold
                  ),),
                  buildInventoryRow(potionInventory, 'potion'),

                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                        'weapon': selectedWeapon,
                        'armor': selectedArmor,
                        'potion': selectedPotion,
                      }, SetOptions(merge: true));

                      Navigator.of(context).pop(); // close the modal
                    },
                    child:
                    const Text("Confirm Selection"),
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

