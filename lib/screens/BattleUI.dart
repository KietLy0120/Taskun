import 'package:flutter/material.dart';
import '../models/battle_log.dart';
import '../models/monster.dart';
import '../helpers/AssetMapper.dart';
import '../widgets/BattleLogWidget.dart';

class BattleUI {
  static Widget buildCharacterSection({
    required String petType,
    required String characterType,
    required int health,
    required int maxHealth,
  }) {
    return Column(
      children: [
        _buildHealthBar(health, maxHealth),
        const SizedBox(height: 8),
        Row(
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
          ],
        ),
      ],
    );
  }

  static Widget buildMonsterSection({
    required Monster monster,
    required int health,
  }) {
    return Column(
      children: [
        _buildHealthBar(health, monster.health),
        const SizedBox(height: 8),
        Image.asset(
          monster.imagePath,
          width: 70,
          height: 70,
        ),
      ],
    );
  }

  static Widget _buildHealthBar(int currentHealth, int maxHealth) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Container(
          width: 100,
          height: 10,
          child: FractionallySizedBox(
            widthFactor: currentHealth / maxHealth,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        Container(
          width: 100,
          height: 10,
          alignment: Alignment.center,
          child: Text(
            '$currentHealth/$maxHealth',
            style: TextStyle(
              fontSize: 8,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildBattleLogs({
    required List<BattleLog> logs,
    required ScrollController controller,
  }) {
    return BattleLogWidget(logs: logs, scrollController: controller);
  }
}