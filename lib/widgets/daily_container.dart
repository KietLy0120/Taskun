import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TasksAndHabitsWidget extends StatelessWidget {
  const TasksAndHabitsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Get today's date

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Today's Date
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Today - $today",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        // Fetch Tasks & Habits from Firebase
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tasks') // Assuming 'tasks' is your collection
                .where('date', isEqualTo: today) // Filter tasks for today
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No tasks or habits for today!"));
              }

              var tasks = snapshot.data!.docs;

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  var task = tasks[index];
                  return ListTile(
                    title: Text(task['title'] ?? 'No title'),
                    subtitle: Text(task['type'] ?? 'Task/Habit'),
                    leading: Icon(
                      task['type'] == 'habit' ? Icons.repeat : Icons.check_circle,
                      color: Colors.indigo,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}