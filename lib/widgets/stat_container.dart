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
        NameEditRow(user: widget.user),
        EmailEditRow(user: widget.user),
        CharacterEditRow(user: widget.user),
        PetEditRow(user: widget.user)
      ],
    );
  }
}
