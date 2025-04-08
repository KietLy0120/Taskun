import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../navigation/navigation_bar.dart';
import '../models/monster.dart';
import '../helpers/AssetMapper.dart';


class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  _BattleScreenState createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {

  late Monster selectedMonster; //store selected monster
  String characterType = ''; // Default values
  String petType = '';

  @override
  void initState() {
    super.initState();
    selectedMonster = monsters[0];
    fetchCharacterAndPet();
  }

  Future<void> fetchCharacterAndPet() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        characterType = doc.data()?['character'] as String? ?? 'Warrior';
        petType = doc.data()?['pet'] as String? ?? 'Dog';
      });
    }
  }

  void updateSelectedMonster(Monster newMonster) {
    setState(() {
      selectedMonster = newMonster;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // This allows the background to extend behind the navbar
      body: Stack(
        children: [
          // Background image covering the entire screen, including behind the navbar
          Positioned.fill(
            child: Image.asset(
              selectedMonster.backgroundPath,
              fit: BoxFit.cover,
            ),
          ),
          // Main content placed on top of the background
          //Floating Action Button
          Positioned(
            bottom: 110,
            left: 20,
            child: FloatingActionButton(
                onPressed: () => _showInventoryPopup(context),
                backgroundColor: Colors.indigo.withOpacity(0.6),
                child: Image.asset(
                  'assets/icons/treasure_bronze_open.png',
                  width: 50,
                  height: 50,
                )
            ),
          ),
          Positioned(
            bottom: 110,
            right: 180,
            child: FloatingActionButton(
                onPressed: () => _showBattlePopup(context),
                backgroundColor: Colors.indigo.withOpacity(0.6),
                child: Image.asset(
                  'assets/icons/icon-battle.png',
                  width: 70,
                  height: 70,
                )
            ),
          ),
          Positioned(
            bottom: 110,
            right: 20,
            child: FloatingActionButton(
                onPressed: () => _showMonstersPopup(context),
                backgroundColor: Colors.indigo.withOpacity(0.6),
                child: Image.asset(
                  monsters[2].imagePath,
                  width: 70,
                  height: 70,
                )
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //CHANGE TO USER'S CHARACTER
                    Image.asset(
                      AssetMapper.getPetAsset(petType),
                      width: 50, height: 50,
                    ),
                    const SizedBox(width:10),

                    Image.asset(AssetMapper.getCharacterAsset(characterType),
                      width:70, height:70,),

                    const SizedBox(width: 170),
                    //CHANGE TO SELECTED ENEMY
                    Image.asset(
                      selectedMonster.imagePath,
                      width: 70, height: 70,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      // Custom bottom navigation bar
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1, // Update with proper state management if needed
        onItemTapped: (index) {
          // Handle navigation based on index
        },
      ),
    );
  }

  void _showInventoryPopup(BuildContext context){
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
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Inventory',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Close"),
                        ),
                      ]
                  )
              )
          );
        }
    );
  }

  void _showBattlePopup(BuildContext context){
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
                      mainAxisSize: MainAxisSize.max,
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
                          onPressed: () {
                            //add battle action
                          },
                          child: const Text(
                              "Start Battle"
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Close"),
                        ),
                      ]
                  )
              )
          );
        }
    );
  }

  void _showMonstersPopup(BuildContext context) {
    PageController pageController = PageController(
      initialPage: monsters.indexOf(selectedMonster),
    );
    int selectedIndex = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) { // Allows UI updates inside the dialog


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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Select a Monster',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Swipeable Monster Cards
                    Expanded(
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: monsters.length,
                        onPageChanged: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final monster = monsters[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Monster Icon
                              Image.asset(
                                monster.imagePath,
                                width: 150,
                                height: 150,
                              ),
                              const SizedBox(height: 10),

                              // Monster Name
                              Text(
                                monster.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Monster Description
                              Text(
                                monster.description,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),

                              // Monster Stats
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Health: ${monster.health}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Text(
                                    "Attack: ${monster.attack}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    ),

                    // Select Button
                    ElevatedButton(
                      onPressed: () {
                        updateSelectedMonster(monsters[selectedIndex]); // Updates main screen
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: const Text("Select"),
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

}