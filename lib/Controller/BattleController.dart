import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  Future<void> updateStats(
      String uid, {
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
    return doc.data() ?? {
      'health': 100,
      'attack': 0,
      'level': 1,
      'experience': 0,
    };
  }
}