import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PetEditRow extends StatefulWidget {
  final User? user;

  const PetEditRow({Key? key, required this.user}) : super(key: key);

  @override
  State<PetEditRow> createState() => _PetEditRowState();
}

class _PetEditRowState extends State<PetEditRow> {
  String _selectedPet = 'Cat';
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentPet();
  }

  Future<void> _loadCurrentPet() async {
    if (widget.user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user!.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        final pet = data?['pet'] ?? 'Cat';
        setState(() {
          _selectedPet = pet;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updatePet() async {
    if (_selectedPet.trim().isNotEmpty && widget.user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user!.uid)
            .update({'pet': _selectedPet});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet updated')),
        );
        setState(() {
          _isEditing = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating pet: $e')),
        );
      }
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
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
                value: _selectedPet,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPet = newValue!;
                  });
                },
                items: <String>['Cat', 'Dog']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
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
                _selectedPet,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ),
          const SizedBox(width: 10),
          _isEditing
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: _updatePet,
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
                  _isEditing = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
