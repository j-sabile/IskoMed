import 'package:flutter/material.dart';
import 'package:health_monitor/test.dart';
import 'package:provider/provider.dart';

// import screens here
import 'models/entry.dart';
import 'models/student.dart';
import 'screens/initial.dart';
// User
import 'screens/Student/login_student.dart';
import 'screens/Student/signup_student.dart';
// import 'screens/Student/add_entry.dart';
// import 'screens/Student/edit_entry.dart';
// import 'screens/Student/home.dart';
// import 'screens/Student/my_profile.dart';
// Admin
import 'screens/Admin/login_admin.dart';
import 'screens/Admin/signup_admin.dart';
// import 'screens/Admin/quarantined.dart';
// import 'screens/Admin/student_requests.dart';
// import 'screens/Admin/under_monitoring_students.dart';
// import 'screens/Admin/view_students.dart';
// Monitor
import 'screens/Monitor/login_monitor.dart';
import 'screens/Monitor/signup_monitor.dart';
// import 'screens/Monitor/read_qr.dart';
// import 'screens/Monitor/student_logs.dart';

// import providers here
import 'providers/auth_provider.dart';
import 'providers/entries_provider.dart';
import 'providers/admin_provider.dart';
import 'providers/monitor_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => EntriesProvider())),
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
        ChangeNotifierProvider(create: ((context) => AdminProvider())),
        ChangeNotifierProvider(create: ((context) => MonitorProvider())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  MaterialColor mycolor = MaterialColor(
      const Color.fromRGBO(107, 107, 191, 1).value, const <int, Color>{
    50: Color.fromRGBO(107, 107, 191, 0.1),
    100: Color.fromRGBO(107, 107, 191, 0.2),
    200: Color.fromRGBO(107, 107, 191, 0.3),
    300: Color.fromRGBO(107, 107, 191, 0.4),
    400: Color.fromRGBO(107, 107, 191, 0.5),
    500: Color.fromRGBO(107, 107, 191, 0.6),
    600: Color.fromRGBO(107, 107, 191, 0.7),
    700: Color.fromRGBO(107, 107, 191, 0.8),
    800: Color.fromRGBO(107, 107, 191, 0.9),
    900: Color.fromRGBO(107, 107, 191, 1),
  });

  // Root of application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Monitoring App',
      initialRoute: '/',
      routes: {
        // insert routes for screens here
        '/': (context) => const InitialPage(),
        // '/test': (context) => const Test(),
        // User
        '/login-user': (context) => const LoginUserPage(),
        '/signup-user': (context) => const UserSignUpPage(),
        // '/addentry': (context) => const AddEntryPage(),
        // '/editentry': (context) => const EditEntryPage(),
        // '/home': (context) => const HomePage(),
        // '/myprofile': (context) => MyProfilePage(entry: getNewEntry()),
        // Admin
        '/login-admin': (context) => const LoginAdminPage(),
        '/signup-admin': (context) => const AdminSignUpPage(),
        // '/quarantined': (context) => const QuarantinedPage(),
        // '/studentrequest': (context) => const StudentRequestPage(),
        // '/undermonitoring': (context) => const UnderMonitoringPage(),
        // '/viewstudents': (context) => const ViewStudentsPage(),
        // Monitor
        '/login-monitor': (context) => const LoginMonitorPage(),
        '/signup-monitor': (context) => const MonitorSignUpPage(),
        // '/readQR': (contect) => const ReadQRPage(),
        // '/studentlogs': (contect) => const StudentLogsPage(),
      },
      // FOR FRONTEND --- theme: ThemeData(),
      theme: ThemeData(primarySwatch: mycolor, fontFamily: 'Nexa'),
    );
  }
}
