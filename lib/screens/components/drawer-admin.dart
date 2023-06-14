import 'package:flutter/material.dart';

import '../Student/home.dart';
import '../Admin/view_students.dart';
import '../Admin/quarantined.dart';
import '../Admin/under_monitoring_students.dart';
import '../Admin/student_requests.dart';

class DrawerAdmin extends StatelessWidget {
  final String userType;
  const DrawerAdmin({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 120,
            child: DrawerHeader(
              child: Text('Admin Functions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(85, 87, 152, 1))),
            ),
          ), 
          ListTile(
            title: const Text("View Students"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewStudentsPage(),
                  ));
            },
          ),
          ListTile(
            title: const Text("Quarantined Students"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuarantinedPage(),
                  ));
            },
          ),
          ListTile(
            title: const Text("Under Monitoring Students"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnderMonitoringPage(),
                  ));
            },
          ),
          ListTile(
            title: const Text("Student Requests"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentRequestPage(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
