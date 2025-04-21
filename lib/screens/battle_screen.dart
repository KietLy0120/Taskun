import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskun/helpers/ButtonAnimator.dart';
import '../navigation/navigation_bar.dart';
import '../models/monster.dart';
import '../helpers/AssetMapper.dart';
import '../widgets/modals/inventory_modal.dart';
import '../widgets/modals/monsters_modal.dart';



class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  _BattleScreenState createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  late Monster selectedMonster;

  @override
  void initState() {
    super.initState();
    selectedMonster = monsters[0];
  }

  Future<Map<String, String>> fetchCharacterAndPet() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      return {
        'character': doc.data()?['character'] ?? '',
        'pet': doc.data()?['pet'] ?? '',
      };
    }
    return {'character': '', 'pet': ''};
  }

  void updateSelectedMonster(Monster newMonster) {
    setState(() {
      selectedMonster = newMonster;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: fetchCharacterAndPet(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final characterType = snapshot.data!['character']!;
        final petType = snapshot.data!['pet']!;

        return Scaffold(
          extendBody: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  selectedMonster.backgroundPath,
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 330),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          AssetMapper.getPetAsset(petType),
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 10),
                        Image.asset(
                          AssetMapper.getCharacterAsset(characterType),
                          width: 70,
                          height: 70,
                        ),
                        const SizedBox(width: 170),
                        Image.asset(
                          selectedMonster.imagePath,
                          width: 70,
                          height: 70,
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                    ButtonAnimator(
                        imagePath: "assets/buttons/battle_button.png",
                        onTap: () => _showBattlePopup(context),
                        width: 250,
                        height: 67
                    ),
                    const SizedBox(height: 10),
                    ButtonAnimator(
                        imagePath: "assets/buttons/monsters_button.png",
                        onTap: () => showMonstersPopup(context, selectedMonster, updateSelectedMonster),
                        width: 250,
                        height: 67
                    ),
                    const SizedBox(height: 10),
                    ButtonAnimator(
                        imagePath: "assets/buttons/inventory_button_02.png",
                        onTap: () => showInventoryPopup(context),
                        width: 250,
                        height: 67
                    ),
                  ],
                ),
              )
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: 1,
            onItemTapped: (index) {},
          ),
        );
      },
    );
  }

  void _showBattlePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.indigo.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Battle Options',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Start Battle"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
