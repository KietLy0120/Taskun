import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../custom_style.dart';

class EditModal {
  static void show(BuildContext context, String taskId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot taskDoc = await firestore.collection('tasks').doc(taskId).get();

    if (!taskDoc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task not found!")),
      );
      return;
    }

    Map<String, dynamic> task = taskDoc.data() as Map<String, dynamic>;

    final TextEditingController titleController = TextEditingController(text: task['title']);
    final TextEditingController descriptionController = TextEditingController(text: task['description']);
    final TextEditingController categoryController = TextEditingController(text: task['category']);
    final TextEditingController startDateController = TextEditingController(text: task['startDate']);
    final TextEditingController pointsController = TextEditingController(text: task['points'].toString());
    final TextEditingController timeReminderController = TextEditingController(text: task['timeReminder']);

    String selectedType = task['type'];
    String repeatedValue = task['repeated'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
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
                            "Edit Task",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.white),
                            onPressed: () async {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("You must be logged in to edit a task!")),
                                );
                                return;
                              }

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
                                await firestore.collection('tasks').doc(taskId).update({
                                  'title': title,
                                  'description': description,
                                  'type': selectedType,
                                  'category': category,
                                  'points': points,
                                  'startDate': startDate,
                                  'timeReminder': timeReminder,
                                  'repeated': repeatedValue,
                                });
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Failed to update task: $e")),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: const Color(0xFF0F3376),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextField(style: const TextStyle(color: Colors.white), controller: titleController, decoration: customInputDecoration('Title')),
                          const SizedBox(height: 15),
                          TextField(style: const TextStyle(color: Colors.white), controller: descriptionController, decoration: customInputDecoration('Description')),
                          const SizedBox(height: 15),
                          TextField(style: const TextStyle(color: Colors.white), controller: categoryController, decoration: customInputDecoration('Category')),
                          const SizedBox(height: 15),
                          TextField(style: const TextStyle(color: Colors.white), controller: pointsController, decoration: customInputDecoration('Points')),
                          const SizedBox(height: 15),
                          TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: startDateController,
                            decoration: customInputDecoration('Start Date'),
                            readOnly: true,
                          ),
                          const SizedBox(height: 15),
                          TextField(style: const TextStyle(color: Colors.white), controller: timeReminderController, decoration: customInputDecoration('Time Reminder')),
                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () async {
                              bool? confirmDelete = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Delete Task"),
                                  content: const Text("Are you sure you want to delete this task?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmDelete == true) {
                                try {
                                  await firestore.collection('tasks').doc(taskId).delete();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Task deleted successfully!")),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Failed to delete task: $e")),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text("Delete", style: TextStyle(color: Colors.white)),
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
