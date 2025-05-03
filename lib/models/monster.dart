class Monster {

  final String id;
  final String name;
  final String imagePath;
  final String description;
  final int health;
  final int attack;
  final String backgroundPath;

  Monster({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.health,
    required this.attack,
    required this.backgroundPath,
  });
}

//Global List of Monsters
final List<Monster> monsters = [
  Monster(
    id: 'thief',
    name: "Thief",
    imagePath: "assets/characters/monster_icons/monster-thief.png",
    description: "A lowly peasant thief",
    health: 150,
    attack: 25,
    backgroundPath: "assets/battle_backgrounds/battle_background0.png",
  ),
  Monster(
    id: 'elf',
    name: "Elf",
    imagePath: "assets/characters/monster_icons/monster-elf.png",
    description: "A feared protector of the forest",
    health: 300,
    attack: 50,
    backgroundPath: "assets/battle_backgrounds/battle_background1.png",
  ),
  Monster(
    id: 'knight',
    name: "Knight",
    imagePath: "assets/characters/monster_icons/monster-knight.png",
    description: "The city's bravest warrior",
    health: 450,
    attack: 75,
    backgroundPath: "assets/battle_backgrounds/battle_background2.png",
  ),
  Monster(
    id: 'fire_dragon',
    name: "Fire Dragon",
    imagePath: "assets/characters/monster_icons/monster-dragon.png",
    description: "A fierce dragon engulfed in flames",
    health: 600,
    attack: 50,
    backgroundPath: "assets/battle_backgrounds/stormy_castle.gif",
  ),
];