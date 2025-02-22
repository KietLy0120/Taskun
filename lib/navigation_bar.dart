import 'package:flutter/material.dart';

import 'battle_screen.dart';
import 'home_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int)? onItemTapped;

  CustomBottomNavBar({required this.selectedIndex, required this.onItemTapped});

  void _handleTap(BuildContext context, int index) {
    // Optionally, notify any external state handler.
    if (onItemTapped != null) {
      onItemTapped!(index);
    }

    // Navigate to the appropriate screen based on the tapped index.
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BattleScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BattleScreen()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BattleScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.grey.withOpacity(0.3),
      elevation: 0,
      // Change the label and icon colors when selected/unselected.
      selectedItemColor: Colors.white,      // Selected color (adjust as needed)
      unselectedItemColor: Colors.blue,     // Unselected color
      items: [
        BottomNavigationBarItem(
          icon: Image.asset('assets/icon-home.png', width: 50, height: 50),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icon-sword.png', width: 50, height: 50),
          label: 'Battle',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icon-paper.png', width: 50, height: 50),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icon-bag.png', width: 50, height: 50),
          label: 'Inventory',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/icon-angel.png', width: 50, height: 50),
          label: 'Setting',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) => _handleTap(context, index),
    );
  }
}
