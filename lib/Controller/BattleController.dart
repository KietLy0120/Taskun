import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helpers/AssetMapper.dart';
import '../models/monster.dart';


class BattleController {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  BattleController({required this.firestore, required this.auth});

  Future<Map<String, String>> fetchCharacterAndPet(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    return {
      'character': doc.data()?['character'] ?? '',
      'pet': doc.data()?['pet'] ?? '',
    };
  }

  Future<void> updateHealth(String uid, int health) async {
    await firestore.collection('users').doc(uid).update({'health': health});
  }

  Future<void> updateStats(String uid, {
    required int level,
    required int experience,
    required int health,
    required int attack,
  }) async {
    await firestore.collection('users').doc(uid).update({
      'level': level,
      'experience': experience,
      'health': health,
      'attack': attack,
    });
  }

  Future<void> recordMonsterDefeat(String uid, String monsterName) async {
    await firestore.collection('users').doc(uid).set({
      'defeatedMonsters': {
        monsterName: DateTime.now(),
      }
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>> fetchCharacterStats(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    final data = doc.data() ?? {};

    int baseHealth = data['health'] ?? 100;
    int baseAttack = data['attack'] ?? 0;

    // Item IDs
    final String? weaponKey = data['weapon'];
    final String? armorKey = data['armor'];
    final String? potionKey = data['potion'];

    // Fetch item bonuses
    int weaponBonus = 0;
    int armorBonus = 0;
    int potionAttackBonus = 0;
    int potionHealthBonus = 0;

    Future<int> getBonus(String? itemId, String field) async {
      if (itemId == null) return 0;
      String? docId = AssetMapper.weaponIds[itemId] ??
          AssetMapper.armorIds[itemId] ??
          AssetMapper.potionIds[itemId];
      if (docId == null) return 0;
      final itemDoc = await firestore.collection('items').doc(docId).get();
      return (itemDoc.data()?[field] ?? 0) as int;
    }

    weaponBonus = await getBonus(weaponKey, 'attackBonus');
    armorBonus = await getBonus(armorKey, 'healthBonus');
    potionAttackBonus = await getBonus(potionKey, 'attackBonus');
    potionHealthBonus = await getBonus(potionKey, 'healthBonus');

    return {
      'health': baseHealth + armorBonus + potionHealthBonus,
      'attack': baseAttack + weaponBonus + potionAttackBonus,
      'level': data['level'] ?? 1,
      'experience': data['experience'] ?? 0,
    };
  }
}