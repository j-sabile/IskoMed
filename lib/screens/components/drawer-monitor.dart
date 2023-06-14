import 'package:flutter/material.dart';

import '../Student/home.dart';
import '../Monitor/student_logs.dart';
import '../Monitor/read_qr.dart';

class DrawerMonitor extends StatelessWidget {
  final String userType;
  const DrawerMonitor({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 120,
            child: DrawerHeader(
              child: Text('Monitor Functions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(85, 87, 152, 1))),
            ),
          ),
          ListTile(
            title: const Text("Student Logs"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentLogsPage(),
                  ));
            },
          ),
          ListTile(
            title: const Text("Read QR"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadQRPage(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
