class AssetMapper {
  static const Map<String, String> characters = {
    'Warrior': 'assets/characters/player_icons/warrior.png',
    'Mage': 'assets/characters/player_icons/mage.png',
  };

  static const Map<String, String> pets = {
    'Dog': 'assets/pets/dog.png',
    'Cat': 'assets/pets/cat.png',
  };

  static String getCharacterAsset(String? characterName) {
    if (characterName == null || characterName.isEmpty) return 'assets/characters/player_icons/warrior.png';
    return characters[characterName] ?? 'assets/characters/player_icons/warrior.png';
  }


  static String getPetAsset(String petName) {
    return pets[petName] ?? 'assets/pets/dog.png';
  }

  static const Map<String, String> armorIds = {
    'Chest Plate': '1',
    'Knight Helmet': '2',
  };

  static const Map<String, String> weaponIds = {
    'Sword': '3',
    'Magic Staff': '4',
  };

  static const Map<String, String> potionIds = {
    'Potion of Vitality': '5',
    'Potion of Strength': '6',
  };

  static const Map<String, int> armorPrices = {
    'Chest Plate': 500,
    'Knight Helmet': 350,
  };

  static const Map<String, int> weaponPrices = {
    'Sword': 100,
    'Magic Staff': 100,
  };

  static const Map<String, int> potionPrices = {
    'Potion of Vitality': 250,
    'Potion of Strength': 250,
  };
}