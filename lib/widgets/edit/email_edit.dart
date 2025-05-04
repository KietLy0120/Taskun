import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailEditRow extends StatefulWidget {
  final User? user;

  const EmailEditRow({Key? key, required this.user}) : super(key: key);

  @override
  State<EmailEditRow> createState() => _EmailEditRowState();
}

class _EmailEditRowState extends State<EmailEditRow> {
  late TextEditingController _emailController;
  String _newEmail = '';
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _loadCurrentEmail();
  }

  Future<void> _loadCurrentEmail() async {
    if (widget.user != null) {
      _emailController.text = widget.user!.email ?? '';
      _newEmail = widget.user!.email ?? '';
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateEmail() async {
    if (_newEmail.trim().isNotEmpty && widget.user != null) {
      try {
        await widget.user!.updateEmail(_newEmail);

        // Update email in Firestore if needed
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user!.uid)
            .update({'email': _newEmail});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email updated')),
        );
        setState(() {
          _isEditing = false; // Disable editing mode after save
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating email: $e')),
        );
      }
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false; // Cancel editing and revert the email
      _emailController.text = _newEmail;
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
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Change Email',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              onChanged: (value) => _newEmail = value,
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
                  onPressed: _updateEmail,
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
