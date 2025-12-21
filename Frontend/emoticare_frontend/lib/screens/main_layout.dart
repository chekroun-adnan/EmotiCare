import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import 'dashboard_screen.dart';
import 'mood_screen.dart';
import 'journal_screen.dart';
import 'goals_screen.dart';
import 'chat_screen.dart';
import 'community_screen.dart';
import 'habits_screen.dart';
import 'digital_twin_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ChatScreen(),
    const HabitsScreen(), // 2
    const DigitalTwinScreen(), // 3
    const MoodScreen(), // 4
    const JournalScreen(), // 5
    const GoalsScreen(), // 6
    const CommunityScreen(), // 7
    const Center(child: Text('Profile')), // 8
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
