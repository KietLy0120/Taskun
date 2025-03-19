class Monster {

  final String name;
  final String imagePath;
  final String description;
  final int health;
  final int attack;
  final String backgroundPath;

  Monster({
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
    name: "Thief",
    imagePath: "assets/icons/monster_icons/monster-thief.png",
    description: "A lowly peasant thief",
    health: 150,
    attack: 25,
    backgroundPath: "assets/battle_backgrounds/battle_background0.png",
  ),
  Monster(
    name: "Elf",
    imagePath: "assets/icons/monster_icons/monster-elf.png",
    description: "A feared protector of the forest",
    health: 300,
    attack: 50,
    backgroundPath: "assets/battle_backgrounds/battle_background1.png",
  ),
  Monster(
    name: "Knight",
    imagePath: "assets/icons/monster_icons/monster-knight.png",
    description: "The city's bravest warrior",
    health: 450,
    attack: 75,
    backgroundPath: "assets/battle_backgrounds/battle_background2.png",
  ),
  Monster(
    name: "Fire Dragon",
    imagePath: "assets/icons/monster_icons/monster-dragon.png",
    description: "A fierce dragon engulfed in flames",
    health: 600,
    attack: 50,
    backgroundPath: "assets/battle_backgrounds/stormy_castle.gif",
  ),
];