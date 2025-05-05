import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskun/widgets/edit/character_edit.dart';
import 'package:taskun/widgets/edit/email_edit.dart';
import 'package:taskun/widgets/edit/pet_edit.dart';
import 'edit/name_edit.dart'; // Import the NameEditRow widget

class StatContainer extends StatefulWidget {
  final User? user;

  const StatContainer({Key? key, required this.user}) : super(key: key);

  @override
  State<StatContainer> createState() => _StatContainerState();
}

class _StatContainerState extends State<StatContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: NameEditRow(user: widget.user)
        ),
        Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: EmailEditRow(user: widget.user)
        ),
        Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CharacterEditRow(user: widget.user)
        ),
        Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: PetEditRow(user: widget.user)
        ),
      ],
    );
  }
}
