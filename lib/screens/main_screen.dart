import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:task_management_app/screens/home_screen.dart';
import 'package:task_management_app/screens/eisenh_page.dart';
import 'package:task_management_app/screens/user_profile_screen.dart';
import 'package:task_management_app/screens/calendar_screen.dart';
import 'package:task_management_app/widgets/add_task_wdg.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    CalendarGrid(),
    EisenhowerMatrixScreen(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 20, 4, 90),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(70),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 29.0, left: 30.0, right: 20.0, bottom: 20.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Task Scheduling Application',
                  style: TextStyle(
                    color: Color.fromARGB(255, 189, 194, 223),
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    fontFamily:'PublicSans-Medium',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color:Color.fromARGB(255, 236, 236, 249),
        index: _selectedIndex,
        backgroundColor: Color.fromARGB(255, 20, 4, 90),
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.calendar_today, size: 30),
          Icon(Icons.flag, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 192, 199, 226), 
        shape: CircleBorder(),
        onPressed: () {
          _showAddTaskBottomSheet(context);
          print('Add button pressed');
        },
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddTaskBottomSheet();
      },
    );
  }
}
