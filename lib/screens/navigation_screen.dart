import 'package:flutter/material.dart';
import 'package:tradersplayground/pages/dashboard_page.dart';
import 'package:tradersplayground/pages/notifications_page.dart';
import 'package:tradersplayground/pages/settings_page.dart';
import 'package:tradersplayground/pages/profile_page.dart';
import '../screens/homescreen.dart';



class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  NavigationScreenState createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    HomeScreen(), // Stocks page is now HomeScreen
    NotificationsPage(),
    SettingsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Keeps all labels visible
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Stocks"), // HomeScreen replaces StocksPage
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Trade"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
