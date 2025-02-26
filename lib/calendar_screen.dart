import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'calendar.dart';
import 'navigation_bar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background3.gif"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Aligning the content properly
          Align(
            alignment: const Alignment(0.0, -0.75), // Centered and slightly shifted up
            child: Column(
              mainAxisSize: MainAxisSize.min, // Prevents unnecessary stretching
              children: [
                // Weekly View
                const Calendar(), // Call the Calendar widget here

                const SizedBox(height: 40),

                // Task placeholder
                Column(
                  mainAxisSize: MainAxisSize.min, // Makes the column wrap its content
                  children: [
                    // Icon underneath the Calendar
                    Image.asset('assets/icon-calendar.png', width: 100, height: 150),

                    const SizedBox(height: 8), // Adds spacing between the icon and the container

                    // Background container with text inside
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Column(
                        children: [
                          const Text(
                              "Nothing planned for today",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "take it easy",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 2, // Set index for calendar screen
        onItemTapped: (index) {
          // Handle navigation logic
        },
      ),
    );
  }
}
