import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'custom_style.dart';

class AddModal {
  static void show(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController startDateController = TextEditingController();
    final TextEditingController pointsController = TextEditingController();
    final TextEditingController timeReminderController = TextEditingController();
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String selectedType = "Task"; // Default selection
    String repeatedValue = "None"; // Default repetition setting

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full-height sheet
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent, // Makes background transparent
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white, // Background color of modal
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Title Row with Close (X) and Save (✔)
                    Container(
                      color: const Color(0xFF28619A),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            "New Task",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.white),
                            onPressed: () async {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("You must be logged in to add a task!")),
                                );
                                return;
                              }

                              // Proceed with adding the task

                              String title = titleController.text;
                              String description = descriptionController.text;
                              String category = categoryController.text;
                              int points = int.tryParse(pointsController.text) ?? 0;
                              String startDate = startDateController.text;
                              String timeReminder = timeReminderController.text;

                              if (title.isEmpty || description.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Title and description cannot be empty!")),
                                );
                                return;
                              }

                              try {
                                await firestore.collection('tasks').add({
                                  'title': title,
                                  'description': description,
                                  'type': selectedType,
                                  'category': category,
                                  'points': points,
                                  'startDate': startDate,
                                  'timeReminder': timeReminder,
                                  'repeated': repeatedValue,
                                  'createdAt': FieldValue.serverTimestamp(),
                                  'userId': user.uid, // Add the userId to associate the task with the user

                                });
                                Navigator.pop(context); // Close modal after saving
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Failed to add task: $e")),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // Content area below the title row
                    Container(
                      color: const Color(0xFF0F3376),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextField(style: const TextStyle(color: Colors.white),controller: titleController, decoration: customInputDecoration('Title')),
                          const SizedBox(height: 15),
                          TextField(style: const TextStyle(color: Colors.white),controller: descriptionController, decoration: customInputDecoration('Description')),
                          const SizedBox(height: 15),

                          Row(children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: selectedType,
                                decoration: customInputDecoration('Type'),
                                dropdownColor: Colors.blueGrey,
                                items: ["Task", "Habit"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(color: Colors.white)),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedType = newValue!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                controller: categoryController,
                                decoration: customInputDecoration('Category'),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 15),

                          TextField(style: const TextStyle(color: Colors.white),controller: pointsController, decoration: customInputDecoration('Points')),
                          const SizedBox(height: 15),

                          TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: startDateController,
                            decoration: customInputDecoration('Start Date'),
                            readOnly: true,
                            onTap: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (selectedDate != null) {
                                startDateController.text = "${selectedDate.toLocal()}".split(' ')[0];
                              }
                            },
                          ),
                          const SizedBox(height: 15),

                          TextField(style: const TextStyle(color: Colors.white),controller: timeReminderController, decoration: customInputDecoration('Time Reminder')),
                          const SizedBox(height: 20),

                          DropdownButtonFormField<String>(
                            decoration: customInputDecoration('Repeated'),
                            dropdownColor: Colors.blueGrey,
                            items: ["Daily", "Weekly", "Monthly", "None"].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                repeatedValue = newValue!;
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text("Cancel"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
