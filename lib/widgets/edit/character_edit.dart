import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CharacterEditRow extends StatefulWidget {
  final User? user;

  const CharacterEditRow({Key? key, required this.user}) : super(key: key);

  @override
  State<CharacterEditRow> createState() => _CharacterEditRowState();
}

class _CharacterEditRowState extends State<CharacterEditRow> {
  String _selectedCharacter = 'Warrior'; // Default selection
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentCharacter();
  }

  Future<void> _loadCurrentCharacter() async {
    if (widget.user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user!.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        final character = data?['character'] ?? 'Warrior'; // Default to Warrior
        setState(() {
          _selectedCharacter = character;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateCharacter() async {
    if (_selectedCharacter.trim().isNotEmpty && widget.user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user!.uid)
            .update({'character': _selectedCharacter});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Character updated')),
        );
        setState(() {
          _isEditing = false; // Disable editing mode after save
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating character: $e')),
        );
      }
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false; // Cancel editing and revert the character
      // Optionally revert the character to the original value, if desired
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _isEditing
                ? DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
                value: _selectedCharacter,
                onChanged: _isEditing
                    ? (String? newValue) {
                  setState(() {
                    _selectedCharacter = newValue!;
                  });
                }
                    : null,
                items: <String>['Warrior', 'Mage']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0), // 👈 Moves text to the right
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
                style: const TextStyle(color: Colors.white),
                dropdownColor: Colors.black.withOpacity(0.8),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                underline: const SizedBox(),
                isExpanded: true,
              ),
            )
                : Text(
              _selectedCharacter,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16, // Same font size as before
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 10),
          _isEditing
              ? Row(
            mainAxisSize: MainAxisSize.min, // Make icons closer
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: _updateCharacter,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: _cancelEdit,
                ),
              ),
            ],
          )
              : Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(5),
            ),
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isEditing = true; // Enable editing mode
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
