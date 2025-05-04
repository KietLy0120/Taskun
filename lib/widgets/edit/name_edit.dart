import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NameEditRow extends StatefulWidget {
  final User? user;

  const NameEditRow({Key? key, required this.user}) : super(key: key);

  @override
  State<NameEditRow> createState() => _NameEditRowState();
}

class _NameEditRowState extends State<NameEditRow> {
  late TextEditingController _nameController;
  String _newName = '';
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadCurrentName();
  }

  Future<void> _loadCurrentName() async {
    if (widget.user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user!.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        final name = data?['name'] ?? 'Player';
        _nameController.text = name;
        _newName = name;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateName() async {
    if (_newName.trim().isNotEmpty && widget.user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user!.uid)
            .update({'name': _newName});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name updated')),
        );
        setState(() {
          _isEditing = false; // Disable editing mode after save
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating name: $e')),
        );
      }
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false; // Cancel editing and revert the name
      _nameController.text = _newName;
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
            child: TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Change Name',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              onChanged: (value) => _newName = value,
              enabled: _isEditing, // Allow editing only when _isEditing is true
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
                  onPressed: _updateName,
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
