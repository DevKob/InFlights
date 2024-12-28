import 'package:flutter/material.dart';
import 'package:inflights_pro/screens/search/search_screen.dart';
import 'package:inflights_pro/screens/tracker/bookmark.dart'; // Import FlightTracker
import '../screens/home/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final appScreens = [
    const HomeScreen(),
    const SearchScreen(),
    BookmarkScreen(), // Ganti dengan FlightTracker
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromRGBO(130, 20, 24, 1),
        unselectedItemColor: Colors.blueGrey,
        backgroundColor: const Color.fromARGB(255, 247, 247, 247),
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Bookmarks"),
        ],
      ),
    );
  }
}
