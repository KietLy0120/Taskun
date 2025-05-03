import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskun/helpers/ButtonAnimator.dart';
import '../models/battle_log.dart';
import '../navigation/navigation_bar.dart';
import '../models/monster.dart';
import '../widgets/modals/inventory_modal.dart';
import '../widgets/modals/monsters_modal.dart';
import '../Controller/BattleController.dart';
import '../screens/BattleUI.dart';
import '../widgets/BattleLogWidget.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  _BattleScreenState createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  final BattleController _controller = BattleController(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance);
      late Monster selectedMonster;
  late int monsterHealth;

  // Player state
  int playerHealth = 100;
  int playerMaxHealth = 100;
  int playerAttack = 0;
  int playerLevel = 1;
  int playerExperience = 0;

  // Battle logs
  final List<BattleLog> battleLogs = [];
  final ScrollController _logScrollController = ScrollController();
  Map<String, DateTime> defeatedMonsters = {};

  @override
  void initState() {
    super.initState();

    selectedMonster = monsters[0];
    monsterHealth = selectedMonster.health;
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadCharacterStats();
    await _loadDefeatedMonsters();
  }

  Future<void> _loadCharacterStats() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final stats = await _controller.fetchCharacterStats(user.uid);
      setState(() {
        playerHealth = stats['health'] ?? 100;
        playerMaxHealth = stats['health'] ?? 100;
        playerAttack = stats['attack'] ?? 0;
        playerLevel = stats['level'] ?? 1;
        playerExperience = stats['experience'] ?? 0;
      });
    }
  }

  Future<void> _loadDefeatedMonsters() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await _controller.firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()?['defeatedMonsters'] != null) {
        setState(() {
          defeatedMonsters = Map<String, DateTime>.from(
              doc.data()!['defeatedMonsters'].map((k, v) =>
                  MapEntry(k, (v as Timestamp).toDate())
              )
          );
        });
      }
    }
  }

  bool _canDefeatMonsterToday(String monsterName) {
    final lastDefeated = defeatedMonsters[monsterName];
    if (lastDefeated == null) return true;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDefeatDay = DateTime(
        lastDefeated.year,
        lastDefeated.month,
        lastDefeated.day
    );

    return !today.isAtSameMomentAs(lastDefeatDay);
  }

  void executePlayerAttack() {
    setState(() {
      monsterHealth -= playerAttack;
      if (monsterHealth < 0) monsterHealth = 0;
      battleLogs.add(BattleLog(
        'You hit ${selectedMonster.name} for $playerAttack damage!',
        Colors.green,
      ));
      _scrollLogsToBottom();
    });
  }

  void executeMonsterAttack() {
    setState(() {
      playerHealth -= selectedMonster.attack;
      if (playerHealth < 0) playerHealth = 0;
      battleLogs.add(BattleLog(
        '${selectedMonster.name} hit you for ${selectedMonster.attack} damage!',
        Colors.red,
      ));
      _scrollLogsToBottom();
    });

    if (playerHealth <= 0) {
      _showDefeatDialog();
    } else {
      _updateHealthOnFirestore();
    }
  }

  void _scrollLogsToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScrollController.hasClients) {
        final position = _logScrollController.position;
        if (position.pixels < position.maxScrollExtent - 10) {
          _logScrollController.animateTo(
            position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  void performBasicAttack() {
    executePlayerAttack();

    if (monsterHealth <= 0) {
      if (_canDefeatMonsterToday(selectedMonster.name)) {
        setState(() {
          playerExperience += 25;
        });
        _recordMonsterDefeat(selectedMonster.name);
        checkLevelUp();
        _showVictoryDialog();
      } else {
        _showAlreadyDefeatedDialog();
      }
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        executeMonsterAttack();
      });
    }
  }

  Future<void> _recordMonsterDefeat(String monsterName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        defeatedMonsters[monsterName] = DateTime.now();
      });
      await _controller.recordMonsterDefeat(user.uid, monsterName);
    }
  }

  Future<void> _updateHealthOnFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _controller.updateHealth(user.uid, playerHealth);
    }
  }

  Future<void> checkLevelUp() async {
    final levelThresholds = {
      1: 50, 2: 100, 3: 200, 4: 350, 5: 550, 6: 800,
    };

    bool leveledUp = false;

    while (levelThresholds[playerLevel] != null &&
        playerExperience >= levelThresholds[playerLevel]!) {
      setState(() {
        playerExperience -= levelThresholds[playerLevel]!;
        playerLevel++;
        playerMaxHealth += 20;
        playerHealth = playerMaxHealth;
        playerAttack += 5;
        leveledUp = true;
      });
    }

    if (leveledUp) {
      _showLevelUpDialog();
      await _saveLevelUpStats();
    }
  }

  void _showLevelUpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('🎉 Level $playerLevel!'),
        content: Text(
          'Stats Increased!\n'
              '+20 Max HP (Now: $playerMaxHealth)\n'
              '+5 Attack (Now: $playerAttack)',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveLevelUpStats() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _controller.updateStats(
        user.uid,
        level: playerLevel,
        experience: playerExperience,
        health: playerHealth,
        attack: playerAttack,
      );
    }
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('🏆 Victory!'),
        content: Text('You defeated the ${selectedMonster.name}! +25 EXP!'),
        actions: [
          TextButton(
            onPressed: () {
              _resetBattleState();
              Navigator.pop(context);
            },
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }

  void _showDefeatDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('💀 Defeated!'),
        content: Text('You were defeated by the ${selectedMonster.name}!'),
        actions: [
          TextButton(
            onPressed: () {
              _resetBattleState();
              Navigator.pop(context);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showAlreadyDefeatedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Already Defeated'),
        content: Text(
            'You already defeated ${selectedMonster.name} today!\n'
                'Try again tomorrow or fight a different monster.'
        ),
        actions: [
          TextButton(
            onPressed: () {
              _resetBattleState();
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetBattleState() async {
    setState(() {
      monsterHealth = selectedMonster.health;
      playerHealth = playerMaxHealth;
      battleLogs.clear();
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _controller.updateHealth(user.uid, playerHealth);
    }
  }

  void updateSelectedMonster(Monster newMonster) {
    setState(() {
      selectedMonster = newMonster;
      monsterHealth = newMonster.health;
    });
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
                  onPressed: () {
                    Navigator.of(context).pop();
                    performBasicAttack();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child: const Text('🗡️ Basic Attack'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _controller.fetchCharacterAndPet(
          FirebaseAuth.instance.currentUser?.uid ?? ''
      ),
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
              BattleUI.buildBattleLogs(
                logs: battleLogs,
                controller: _logScrollController,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 330),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BattleUI.buildCharacterSection(
                          petType: petType,
                          characterType: characterType,
                          health: playerHealth,
                          maxHealth: playerMaxHealth,
                        ),
                        BattleUI.buildMonsterSection(
                          monster: selectedMonster,
                          health: monsterHealth,
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                    ButtonAnimator(
                      imagePath: "assets/buttons/battle_button.png",
                      onTap: () => _showBattlePopup(context),
                      width: 250,
                      height: 67,
                    ),
                    const SizedBox(height: 10),
                    ButtonAnimator(
                      imagePath: "assets/buttons/monsters_button.png",
                      onTap: () => showMonstersPopup(
                        context,
                        selectedMonster,
                        updateSelectedMonster,
                      ),
                      width: 250,
                      height: 67,
                    ),
                    const SizedBox(height: 10),
                    ButtonAnimator(
                      imagePath: "assets/buttons/inventory_button_02.png",
                      onTap: () => showInventoryPopup(context),
                      width: 250,
                      height: 67,
                    ),
                  ],
                ),
              ),
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
}