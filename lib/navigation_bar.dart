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

  // Helper method to build the default icon.
  Widget _buildIcon(String assetName) {
    return Image.asset(assetName, width: 50, height: 50);
  }

  // Helper method to build the active icon with a grey square background.
  Widget _buildActiveIcon(String assetName) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey[600], // Grey square background
        borderRadius: BorderRadius.circular(9.0), // Rounded corners (adjust as needed)
      ),
      child: Center(
        child: Image.asset(assetName, width: 50, height: 50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      elevation: 0,
      // The color properties here won't affect the icon if you use activeIcon
      // but you can still define them if needed.
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.blue,
      items: [
        BottomNavigationBarItem(
          icon: _buildIcon('assets/icon-home.png'),
          activeIcon: _buildActiveIcon('assets/icon-home.png'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/icon-sword.png'),
          activeIcon: _buildActiveIcon('assets/icon-sword.png'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/icon-paper.png'),
          activeIcon: _buildActiveIcon('assets/icon-paper.png'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/icon-bag.png'),
          activeIcon: _buildActiveIcon('assets/icon-bag.png'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/icon-angel.png'),
          activeIcon: _buildActiveIcon('assets/icon-angel.png'),
          label: '',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) => _handleTap(context, index),
    );
  }
}