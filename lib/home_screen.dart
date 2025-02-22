import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Home"),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.logout),
      //       onPressed: () async {
      //         await FirebaseAuth.instance.signOut();
      //         Navigator.pushReplacement(
      //           context,
      //           MaterialPageRoute(builder: (context) => LoginScreen()),
      //         );
      //       },
      //     )
      //   ],
      // ),
      body: Stack(
        children: [
          // Background image covering the entire screen
          Positioned.fill(
            child: Image.asset(
              "assets/home-bg.png",
              fit: BoxFit.cover,
            ),
          ),
          // Column holding the main content and the custom bottom nav bar
          Column(
            children: [
              // Expanded widget takes all available space above the nav bar
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome, ${user?.email ?? "User"}!",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
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
              // Custom bottom navigation bar placed at the bottom of the Column
              CustomBottomNavBar(
                selectedIndex: 0, // Update with proper state management if needed
                onItemTapped: (index) {
                  // Handle navigation based on index
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}