import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/add_button.dart';
import '../widgets/add_modal.dart';
import '../auth/login_screen.dart';
import '../navigation/navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image covering the entire screen
          Positioned.fill(
            child: Image.asset(
              "assets/backgrounds/home-bg.png",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome, ${user?.email ?? "User"}!",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Logout"),
                      ),
                    ],
                  ),
                ),
              ),
              // Floating action button aligned above bottom navigation
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CustomAddButton(
                    onPressed: () => AddModal.show(context),
                  ),
                ),
              ),
              CustomBottomNavBar(
                selectedIndex: 0,
                onItemTapped: (index) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}