import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'modals/edit_modal.dart';

class DailyContainer extends StatefulWidget {
  final User? user;

  const DailyContainer({Key? key, required this.user}) : super(key: key);

  @override
  _DailyContainerState createState() => _DailyContainerState();
}

class _DailyContainerState extends State<DailyContainer> with AutomaticKeepAliveClientMixin {
  late List<TaskItem> taskWidgets;
  DateTime _selectedDate = DateTime.now();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    taskWidgets = [];
  }

  void _goToPreviousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 1));
    });
  }

  void _goToNextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String formattedDate = DateFormat('EEEE, MMM d, yyyy').format(_selectedDate);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.white),
                onPressed: _goToPreviousDay,
              ),
              Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: Colors.white),
                onPressed: _goToNextDay,
              ),
            ],
          ),
        ),
        Flexible(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .where('userId', isEqualTo: widget.user?.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return _buildEmptyState();
              }

              List<QueryDocumentSnapshot> filteredDocs = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;

                if (data['startDate'] == null) return false;

                try {
                  final DateTime startDate = DateTime.parse(data['startDate']);
                  return !startDate.isAfter(_selectedDate); // equivalent to startDate <= selectedDate
                } catch (e) {
                  return false; // Invalid date format
                }
              }).toList();

              if (filteredDocs.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                key: PageStorageKey('daily-task-list'),
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  final doc = filteredDocs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  return TaskItem(
                    key: ValueKey(doc.id),
                    taskId: doc.id,
                    title: data['title'],
                    description: data['description'],
                    points: data['points'] ?? 0,
                    user: widget.user,
                    finished: data['finished'] ?? 0,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          Image.asset('assets/icons/icon-calendar.png', width: 80, height: 130),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Text(
                  "Nothing planned for this day",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "take it easy",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


class TaskItem extends StatefulWidget {
  final String taskId;
  final String title;
  final String description;
  final int points;
  final User? user;
  final int finished;

  const TaskItem({
    Key? key,
    required this.taskId,
    required this.title,
    required this.description,
    required this.points,
    required this.user,
    required this.finished,
  }) : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> with AutomaticKeepAliveClientMixin {
  late Color taskColor;
  late Color upArrowColor;
  late Color downArrowColor;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _setColors(widget.finished);
  }

  void _setColors(int finished) {
    if (finished == 1) {
      taskColor = Colors.red;
      upArrowColor = Colors.red;
      downArrowColor = Colors.grey;
    } else if (finished == -1) {
      taskColor = Colors.blue;
      upArrowColor = Colors.grey;
      downArrowColor = Colors.blue;
    } else {
      taskColor = Colors.grey[300]!;
      upArrowColor = Colors.grey;
      downArrowColor = Colors.grey;
    }
  }

  void setColorsFromFinished(int finished) {
    if (!mounted) return;
    setState(() {
      _setColors(finished);
    });
  }

  void updateTaskColor(bool isUp) async {
    int newFinishedValue = 0;

    if (isUp) {
      if (upArrowColor == Colors.red) {
        setColorsFromFinished(0);
        newFinishedValue = 0;
      } else {
        setColorsFromFinished(1);
        newFinishedValue = 1;
        await _updateUserCoins(widget.points);
      }
    } else {
      if (downArrowColor == Colors.blue) {
        setColorsFromFinished(0);
        newFinishedValue = 0;
      } else {
        setColorsFromFinished(-1);
        newFinishedValue = -1;
        await _updateUserCoins(-widget.points);
      }
    }

    await _updateTaskFinishedStatus(newFinishedValue);
  }

  Future<void> _updateTaskFinishedStatus(int finishedValue) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .update({'finished': finishedValue});
  }

  Future<void> _updateUserCoins(int taskPoints) async {
    if (widget.user != null) {
      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user!.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot userDoc = await transaction.get(userRef);
        if (!userDoc.exists) return;

        int currentCoins = userDoc['coins'] ?? 0;
        int newCoinValue = currentCoins + taskPoints;

        transaction.update(userRef, {'coins': newCoinValue});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
