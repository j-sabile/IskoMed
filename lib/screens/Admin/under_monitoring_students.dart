import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_monitor/providers/admin_provider.dart';
import 'package:provider/provider.dart';

import '../../models/student_model.dart';

class UnderMonitoringPage extends StatefulWidget {
  const UnderMonitoringPage({super.key});

  @override
  State<UnderMonitoringPage> createState() => _UnderMonitoringPageState();
}

class _UnderMonitoringPageState extends State<UnderMonitoringPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Under Monitoring Students")),
        body: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: displayUnderMonitoringStudents(context),
        ));
  }

  Widget displayUnderMonitoringStudents(BuildContext context) {
    Stream<QuerySnapshot> underMonitoringStream =
        context.watch<AdminProvider>().underMonitoringStudents;

    return StreamBuilder(
      stream: underMonitoringStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error encountered! ${snapshot.error}"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No Under Monitoring Students!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(85, 87, 152, 1))));
        } else {
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context2, int index) {
              StudentModel student = StudentModel.fromJson(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);
              return Container(
                  padding: const EdgeInsets.all(5),
                  child: Material(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: displayStudentTile(
                          student, snapshot.data!.docs[index].id)));
            },
          );
        }
      },
    );
  }

// returns a ListTile of a student
  ListTile displayStudentTile(StudentModel student, String studentId) {
    return ListTile(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 3, color: Color.fromRGBO(85, 87, 152, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(student.name),
      trailing: PopupMenuButton(
        itemBuilder: (context2) => [
          // Move to Quarantine Option
          PopupMenuItem(
            onTap: () async {
              String result = await context2
                  .read<AdminProvider>()
                  .moveToQuarantined(studentId);
              if (result == "success" && context.mounted) {
                SnackBar snackBar = SnackBar(
                    content: Text(
                        "Successfully moved ${student.name} to qurantined"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: const Text("Move to quarantine"),
          ),

          // End Monitoring Option
          PopupMenuItem(
            onTap: () async {
              String result =
                  await context2.read<AdminProvider>().clearStatus(studentId);
              if (result == "success" && context.mounted) {
                SnackBar snackBar = SnackBar(
                    content: Text("Successfully cleared ${student.name}"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: const Text("End monitoring"),
          ),
        ],
      ),
    );
  }
}
