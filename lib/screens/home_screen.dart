import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/add_button.dart';
import '../widgets/add_modal.dart';
import '../auth/login_screen.dart';
import '../navigation/navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/backgrounds/home-bg.png", fit: BoxFit.cover),
          ),
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('tasks')
                      .where('userId', isEqualTo: user?.uid) // Filter tasks by userId
                      .orderBy('createdAt', descending: true)
                      .snapshots(),

                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No tasks found!"));
                    }

                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        Map<String, dynamic> task = doc.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(task['title']),
                          subtitle: Text(task['description']),
                          trailing: Text(task['category']),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              CustomAddButton(
                onPressed: () => AddModal.show(context),
              ),
              CustomBottomNavBar(selectedIndex: 0, onItemTapped: (index) {}),
            ],
          ),
        ],
      ),
    );
  }
}