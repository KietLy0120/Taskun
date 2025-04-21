import 'package:flutter/material.dart';

import '../screens/battle_screen.dart';
import '../screens/home_screen.dart';
import '../screens/calendar_screen.dart';
import '../screens/shop_screen.dart';
import '../screens/setting_screen.dart';

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
    Widget screen;
    switch (index) {
      case 0:
        screen = HomeScreen();
        break;
      case 1:
        screen = BattleScreen();
        break;
      case 2:
        screen = CalendarScreen();
        break;
      case 3:
        screen = ShopScreen();
        break;
      case 4:
        screen = HomeScreen();
        break;
      default:
        return; // Do nothing if index is out of range
    }

    // Replace the current screen with the selected one
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
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
          icon: _buildIcon('assets/icons/icon-home.png'),
          activeIcon: _buildActiveIcon('assets/icons/icon-home.png'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/icons/icon-sword.png'),
          activeIcon: _buildActiveIcon('assets/icons/icon-sword.png'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/icons/icon-paper.png'),
          activeIcon: _buildActiveIcon('assets/icons/icon-paper.png'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/icons/coin_gold_02.png'),
          activeIcon: _buildActiveIcon('assets/icons/coin_gold_02.png'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/icons/icon-angel.png'),
          activeIcon: _buildActiveIcon('assets/icons/icon-angel.png'),
          label: '',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) => _handleTap(context, index),
    );
  }
}