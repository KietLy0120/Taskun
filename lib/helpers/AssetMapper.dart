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
    'chest plate': '1',
    'knight helmet': '2',
  };

  static const Map<String, String> weaponIds = {
    'sword': '3',
    'magic_staff': '4',
  };

  static const Map<String, String> potionIds = {
    'potion of vitality': '5',
    'potion of strength': '6',
  };

  static const Map<String, int> armorPrices = {
    'chest plate': 500,
    'knight helmet': 350,
  };

  static const Map<String, int> weaponPrices = {
    'sword': 100,
    'magic_staff': 100,
  };

  static const Map<String, int> potionPrices = {
    'potion of vitality': 250,
    'potion of strength': 250,
  };
}