import 'package:flutter/material.dart';

class CustomAddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomAddButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.white, // Customize the button color as needed
      child: const Icon(
        Icons.add,
        size: 30,
      ),
    );
  }
}