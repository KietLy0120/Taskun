import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskun/widgets/edit_modal.dart';

class DailyContainer extends StatefulWidget {
  final User? user;

  const DailyContainer({Key? key, required this.user}) : super(key: key);

  @override
  _DailyContainerState createState() => _DailyContainerState();
}

class _DailyContainerState extends State<DailyContainer> {
  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            todayDate,
            style: TextStyle(
              color: Colors.white, // White color for the text
              fontSize: 24, // Larger font size
              fontWeight: FontWeight.bold, // Optional: Make it bold
            ),
          ),
        ),
        Flexible(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .where('userId', isEqualTo: widget.user?.uid)
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No tasks found!"));
              }

              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> task = doc.data() as Map<String, dynamic>;
                  String taskId = doc.id;

                  return TaskItem(
                    taskId: taskId,
                    title: task['title'],
                    description: task['description'],
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TaskItem extends StatefulWidget {
  final String taskId;
  final String title;
  final String description;

  const TaskItem({
    Key? key,
    required this.taskId,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  Color taskColor = Colors.grey[300]!;
  Color upArrowColor = Colors.grey;
  Color downArrowColor = Colors.grey;

  void updateTaskColor(bool isUp) {
    setState(() {
      if (isUp) {
        // If up arrow is already red, turn it back to grey
        if (upArrowColor == Colors.red) {
          taskColor = Colors.grey[300]!;
          upArrowColor = Colors.grey;
          downArrowColor = Colors.grey;
        } else {
          taskColor = Colors.red;
          upArrowColor = Colors.red;
          downArrowColor = Colors.grey;
        }
      } else {
        // If down arrow is already blue, turn it back to grey
        if (downArrowColor == Colors.blue) {
          taskColor = Colors.grey[300]!;
          downArrowColor = Colors.grey;
          upArrowColor = Colors.grey;
        } else {
          taskColor = Colors.blue;
          downArrowColor = Colors.blue;
          upArrowColor = Colors.grey;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_downward, color: downArrowColor),
            onPressed: () => updateTaskColor(false),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                EditModal.show(context, widget.taskId);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: taskColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.description,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_upward, color: upArrowColor),
            onPressed: () => updateTaskColor(true),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
