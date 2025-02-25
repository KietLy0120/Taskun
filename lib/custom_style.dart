import 'package:flutter/material.dart';

InputDecoration customInputDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.white), // White label text
    filled: true, // Enable background fill
    fillColor: Colors.white10, // Set background color (default: white)
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white), // White border
      borderRadius: BorderRadius.circular(4), // Optional: Adjust border radius
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white), // White border when not focused
      borderRadius: BorderRadius.circular(4),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white), // White border when focused
      borderRadius: BorderRadius.circular(4),
    ),
  );
}