import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../helpers/AssetMapper.dart';

void showInventoryPopup(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  final userData = userDoc.data() ?? {};

  Future<List<Map<String, dynamic>>> fetchItemsByType(String type) async {
    final query = await FirebaseFirestore.instance
        .collection('items')
        .where('type', isEqualTo: type)
        .get();

    return query.docs.map((doc) => doc.data()).toList();
  }

  String? weaponKey = userData['weapon'];
  String? armorKey = userData['armor'];
  String? potionKey = userData['potion'];

  String? selectedWeapon = weaponKey;
  String? selectedArmor = armorKey;
  String? selectedPotion = potionKey;



  List<Map<String, dynamic>> weaponInventory = [];
  List<Map<String, dynamic>> armorInventory = [];
  List<Map<String, dynamic>> potionInventory = [];

  weaponInventory = await fetchItemsByType('weapon');
  armorInventory = await fetchItemsByType('armor');
  potionInventory = await fetchItemsByType('potion');

  Future<Map<String, dynamic>?> fetchItem(String? id) async {
    if (id == null) return null;
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
                            ],
                          ),
                        ],
                      ),
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
                  final itemId = item['name'].toString().toLowerCase();

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
                    height: 220,
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
                    child: const Text("Confirm Selection"),
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

