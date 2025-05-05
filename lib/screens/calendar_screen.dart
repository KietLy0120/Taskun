import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/calendar.dart';
import '../navigation/navigation_bar.dart';
import '../widgets/daily_container.dart'; // if TaskItem is stored here

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? _selectedDay = DateTime.now();

  void _updateSelectedDay(DateTime? day) {
    setState(() {
      _selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/backgrounds/background3.gif"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.0, -0.75),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Calendar(onDaySelected: _updateSelectedDay),
                const SizedBox(height: 40),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('tasks')
                      .where('userId', isEqualTo: currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final docs = snapshot.data!.docs.where((doc) {
                      final data = doc.data();
                      if (data['startDate'] == null) return false;
                      try {
                        final taskDate = DateTime.parse(data['startDate']);
                        return taskDate.year == _selectedDay?.year &&
                            taskDate.month == _selectedDay?.month &&
                            taskDate.day == _selectedDay?.day;
                      } catch (_) {
                        return false;
                      }
                    }).toList();

                    if (docs.isEmpty) {
                      return Column(
                        children: [
                          Image.asset('assets/icons/icon-calendar.png', width: 100, height: 150),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Column(
                              children: [
                                Text("Nothing planned for today", style: TextStyle(color: Colors.white, fontSize: 16)),
                                Text("take it easy", style: TextStyle(color: Colors.white70, fontSize: 14)),
                              ],
                            ),
                          )
                        ],
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data();
                        return TaskItem(
                          taskId: docs[index].id,
                          title: data['title'],
                          description: data['description'],
                          points: data['points'] ?? 0,
                          user: currentUser,
                          finished: data['finished'] ?? 0,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 2,
        onItemTapped: (index) {
          // Handle navigation
        },
      ),
    );
  }
}
