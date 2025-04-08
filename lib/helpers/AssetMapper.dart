class AssetMapper {
  static const Map<String, String> characters = {
    'Warrior': 'assets/characters/warrior.png',
    'Mage': 'assets/characters/mage.png',
  };

  static const Map<String, String> pets = {
    'Dog': 'assets/pets/dog.png',
    'Cat': 'assets/pets/cat.png',
  };

  static String getCharacterAsset(String characterName) {
    return characters[characterName] ?? 'assets/characters/warrior.png';
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
    'magic staff': '4',
  };

  static const Map<String, String> potionIds = {
    'potion of vitality': '5',
    'potion of strength': '6',
  };
}