import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart'; // For rootBundle

class CharacterSelectionScreen extends StatefulWidget {
  @override
  _CharacterSelectionScreenState createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  String? selectedCharacter;
  String? selectedPet;
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  bool isSaving = false;

  final Map<String, String> characters = {
    "Warrior": "assets/characters/warrior.png",
    "Mage": "assets/characters/mage.png",
  };

  final Map<String, String> pets = {
    "Dog": "assets/pets/dog.png",
    "Cat": "assets/pets/cat.png",
  };

  void saveSelection() async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not authenticated. Please log in.")),
      );
      return;
    }

    if(_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a name.")),
      );
      return;
    }

    if (selectedCharacter == null || selectedPet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both a character and a pet!")),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'character': selectedCharacter,
        'pet': selectedPet,
        'name': _nameController.text.trim(),
      }, SetOptions(merge: true));

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save selection: ${e.toString()}")),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }


  // // Helper function to upload an image to Firebase Storage and return the download URL
  // Future<String> uploadImageToFirebaseStorage(String assetPath, String storagePath) async {
  //   // Load the image from assets as ByteData
  //   final ByteData byteData = await rootBundle.load(assetPath);
  //
  //   // Convert ByteData to Uint8List
  //   final Uint8List fileBytes = byteData.buffer.asUint8List();
  //
  //   // Upload the file to Firebase Storage
  //   final storageRef = FirebaseStorage.instance.ref().child(storagePath);
  //   await storageRef.putData(fileBytes);
  //
  //   // Return the download URL
  //   return await storageRef.getDownloadURL();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      // Background image
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/backgrounds/background.gif",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 100, left: 20, right: 20, bottom: 100
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Name your Character",
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Your Name",
                        hintStyle: const TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: Colors.white38,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Select Your Character",
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      children: characters.entries.map((entry) {
                        final characterName = entry.key;
                        final characterImage = entry.value;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCharacter = characterName;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedCharacter == characterName ? Colors.blue : Colors.transparent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              characterImage,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Select Your Pet",
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      children: pets.entries.map((entry) {
                        final petName = entry.key;
                        final petImage = entry.value;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPet = petName;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedPet == petName ? Colors.blue : Colors.transparent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              petImage,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: isSaving ? null : saveSelection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: isSaving
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Text("Confirm"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      )
    );
  }
}