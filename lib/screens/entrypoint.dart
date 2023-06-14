import 'package:flutter/material.dart';
import 'package:health_monitor/screens/Student/signup_student.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

// Screens
import 'components/drawer-admin.dart';
import 'components/drawer-monitor.dart';
import 'Student/home.dart';
import 'Student/my_profile.dart';
import 'Student/add_entry.dart';
import 'Student/edit_entry.dart';

// user routed to this page after login
class EntryPointPage extends StatefulWidget {
  final String userType;

  const EntryPointPage({super.key, required this.userType});
  @override
  _EntryPointPageState createState() => _EntryPointPageState();
}

class _EntryPointPageState extends State<EntryPointPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      HomePage(userType: widget.userType),
      AddEntryPage(userType: widget.userType),
      MyProfilePage(entry: getNewEntry(), userType: widget.userType),
    ];

    final bottomNavBar = BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xFF6B6BBF)),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded),
            label: 'Add Entry',
            backgroundColor: Color(0xFF6B6BBF)),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Color(0xFF6B6BBF)),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );

    if (widget.userType == "Student") {
      return Scaffold(
        appBar: AppBar(title: const Text("Home Page"), actions: [
          ElevatedButton(
            onPressed: () async {
              await context.read<AuthProvider>().signOut();
              Navigator.popUntil(context, (route) => false);
              Navigator.pushNamed(context, '/');
            },
            child: Text("Logout"),
          )
        ]),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: bottomNavBar,
      );
    } else if (widget.userType == "Admin") {
      return Scaffold(
        drawer: DrawerAdmin(userType: widget.userType),
        appBar: AppBar(title: const Text("Home Page"), actions: [
          ElevatedButton(
            onPressed: () async {
              await context.read<AuthProvider>().signOut();
              Navigator.popUntil(context, (route) => false);
              Navigator.pushNamed(context, '/');
            },
            child: Text("Logout"),
          )
        ]),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: bottomNavBar,
      );
    } else {
      return Scaffold(
        drawer: DrawerMonitor(userType: widget.userType),
        appBar: AppBar(title: const Text("Home Page"), actions: [
          ElevatedButton(
            onPressed: () async {
              await context.read<AuthProvider>().signOut();
              Navigator.popUntil(context, (route) => false);
              Navigator.pushNamed(context, '/');
            },
            child: Text("Logout"),
          )
        ]),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: bottomNavBar,
      );
    }
  }
}
