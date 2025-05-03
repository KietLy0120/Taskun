import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/AssetMapper.dart';

class CharacterSelectionScreen extends StatefulWidget {
  @override
  _CharacterSelectionScreenState createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  String? selectedCharacter;
  String? selectedPet;
  String? selectedWeapon;
  String? selectedArmor;
  String? selectedPotion;
  String? characterBonusLabel;
  String? petBonusLabel;

  int baseHealth = 0;
  int baseAttack = 0;
  int health = 0;
  int attack = 0;

  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  bool isSaving = false;

  final Map<String, String> characters = {
    "Warrior": "assets/characters/player_icons/warrior.png",
    "Mage": "assets/characters/player_icons/mage.png",
  };

  final Map<String, String> pets = {
    "Dog": "assets/pets/dog.png",
    "Cat": "assets/pets/cat.png",
  };

  void saveSelection() async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not authenticated. Please log in.")),
      );
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a name.")),
      );
      return;
    }

    if (selectedCharacter == null || selectedPet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both a character and a pet!")),
      );
      return;
    }

    setState(() => isSaving = true);

    //default inventory setup
    List<String> startingWeapons = [];
    if (selectedCharacter == 'Warrior') {
      startingWeapons = ['Sword'];
    } else if (selectedCharacter == 'Mage') {
      startingWeapons = ['Magic Staff'];
    }

    final inventory = {
      'weapons': startingWeapons,
      'armor': [],
      'potions': [],
    };

    try {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'character': selectedCharacter,
        'pet': selectedPet,
        'name': _nameController.text.trim(),
        'health': health,
        'attack': attack,
        'coins': 0,
        'weapon': selectedWeapon,
        'armor': selectedArmor,
        'potion': selectedPotion,
        'inventory': inventory,
      }, SetOptions(merge: true));

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save selection: ${e.toString()}")),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset("assets/backgrounds/background.gif", fit: BoxFit.cover),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 80),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Name your Character", style: TextStyle(color: Colors.black, fontSize: 24)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Your Name",
                      hintStyle: const TextStyle(color: Colors.black54),
                      filled: true,
                      fillColor: Colors.white38,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Select Your Character", style: TextStyle(color: Colors.black, fontSize: 24)),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    children: characters.entries.map((entry) {
                      final characterName = entry.key;
                      final characterImage = entry.value;
                      return GestureDetector(
                        onTap: () async {
                          String weaponId;
                          String weaponName;

                          if (characterName == 'Warrior') {
                            weaponId = AssetMapper.weaponIds['Sword']!;
                            baseHealth = 100;
                            baseAttack = 80;
                            weaponName = 'Sword';
                            selectedWeapon = 'Sword';
                          } else {
                            weaponId = AssetMapper.weaponIds['Magic Staff']!;
                            baseHealth = 80;
                            baseAttack = 100;
                            weaponName = 'Magic Staff';
                            selectedWeapon = 'Magic Staff';
                          }

                          final weaponDoc = await FirebaseFirestore.instance
                              .collection('items')
                              .doc(weaponId)
                              .get();

                          final weaponData = weaponDoc.data();
                          final int weaponAttackBonus = (weaponData?['attackBonus'] ?? 0) as int;

                          int updatedHealth = baseHealth;
                          int updatedAttack = baseAttack + weaponAttackBonus;

                          if (selectedPet == 'Dog') updatedAttack += 10;
                          if (selectedPet == 'Cat') updatedHealth += 10;

                          setState(() {
                            selectedCharacter = characterName;
                            selectedArmor = null;
                            selectedPotion = null;
                            health = updatedHealth;
                            attack = updatedAttack;
                            characterBonusLabel = '+$weaponAttackBonus $weaponName Bonus';
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedCharacter == characterName ? Colors.blue : Colors.transparent,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(characterImage, width: 100, height: 100, fit: BoxFit.cover),
                            ),
                            if (selectedCharacter == characterName && characterBonusLabel != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  characterBonusLabel!,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                                ),
                              )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(children: [
                        const Text("Health", style: TextStyle(color: Colors.black)),
                        const SizedBox(width: 5),
                        const Icon(Icons.favorite, color: Colors.red),
                        const SizedBox(width: 5),
                        Container(width: health.toDouble() / 2, height: 12, color: Colors.red),
                      ]),
                      Row(children: [
                        const Text("Attack", style: TextStyle(color: Colors.black)),
                        const SizedBox(width: 5),
                        const Icon(Icons.bolt, color: Colors.blue),
                        const SizedBox(width: 5),
                        Container(width: attack.toDouble() / 2, height: 12, color: Colors.blue),
                      ])
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Select Your Pet", style: TextStyle(color: Colors.black, fontSize: 24)),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    children: pets.entries.map((entry) {
                      final petName = entry.key;
                      final petImage = entry.value;
                      return GestureDetector(
                        onTap: () async {
                          int updatedHealth = baseHealth;
                          int updatedAttack = baseAttack;

                          if (selectedWeapon != null) {
                            final weaponId = AssetMapper.weaponIds[selectedWeapon!];
                            if (weaponId != null) {
                              final weaponDoc = await FirebaseFirestore.instance
                                  .collection('items')
                                  .doc(weaponId)
                                  .get();
                              final weaponData = weaponDoc.data();
                              final int weaponAttackBonus = (weaponData?['attackBonus'] ?? 0) as int;

                              updatedAttack += weaponAttackBonus;
                            }
                          }

                          // Apply pet bonus
                          if (petName == 'Dog') {
                            updatedAttack += 10;
                            petBonusLabel = '+10 Dog Bonus';
                          } else if (petName == 'Cat') {
                            updatedHealth += 10; petBonusLabel = '+10 Cat Bonus';
                          }

                          setState(() {
                            selectedPet = petName;
                            health = updatedHealth;
                            attack = updatedAttack;
                          });
                        },

                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedPet == petName ? Colors.blue : Colors.transparent,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(petImage, width: 100, height: 100, fit: BoxFit.cover),
                            ),
                            if(selectedPet == petName && petBonusLabel != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  petBonusLabel!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: isSaving ? null : saveSelection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Confirm"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
