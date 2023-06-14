import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_monitor/providers/admin_provider.dart';
import 'package:provider/provider.dart';

import '../../models/student_model.dart';

class StudentRequestPage extends StatefulWidget {
  const StudentRequestPage({super.key});

  @override
  State<StudentRequestPage> createState() => _StudentRequestPageState();
}

class _StudentRequestPageState extends State<StudentRequestPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> editRequestsStream =
        context.watch<AdminProvider>().editEntryRequestsStream;
    Stream<QuerySnapshot> deleteRequestsStream =
        context.watch<AdminProvider>().deleteEntryRequestsStream;

    return Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Edit Requests"),
              Tab(text: "Delete Requests")
            ],
          ),
          title: const Text("Student Requests"),
        ),
        body: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: TabBarView(controller: _tabController, children: [
              displayRequests(context, editRequestsStream, "Edit"),
              displayRequests(context, deleteRequestsStream, "Delete"),
            ])));
  }

  StreamBuilder displayRequests(
      BuildContext context, Stream<QuerySnapshot> stream, String type) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error encountered! ${snapshot.error}"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text("No $type Entry Requests!",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(85, 87, 152, 1))));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              StudentModel student = StudentModel.fromJson(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);
              return dismissibleStudent(
                  context, student, snapshot.data!.docs[index].id, type);
            },
          );
        }
      },
    );
  }

  Dismissible dismissibleStudent(BuildContext context, StudentModel student,
      String studentId, String type) {
    return Dismissible(
        key: Key(studentId),
        direction: DismissDirection.horizontal,
        background: Container(
          color: Colors.green,
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Icon(Icons.check, color: Colors.white),
            ),
          ),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          child: const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
        onDismissed: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            late String result;
            if (type == "Edit") {
              result = await context
                  .read<AdminProvider>()
                  .approveEditRequest(studentId);
            } else if (type == "Delete") {
              result = await context
                  .read<AdminProvider>()
                  .approveDeleteRequest(studentId);
            }
            if (result == "success" && context.mounted) {
              SnackBar snackBar = SnackBar(
                  content: Text(
                      "Successfully approved $type request of ${student.name}."));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } else if (direction == DismissDirection.endToStart) {
            late String result;
            if (type == "Edit") {
              result = await context
                  .read<AdminProvider>()
                  .rejectEditRequest(studentId);
            } else if (type == "Delete") {
              result = await context
                  .read<AdminProvider>()
                  .rejectDeleteRequest(studentId);
            }
            if (result == "success" && context.mounted) {
              SnackBar snackBar = SnackBar(
                  content: Text(
                      "Successfully rejected $type request of ${student.name}."));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
        },
        child: Container(
            padding: const EdgeInsets.all(5),
            child: Material(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 4, color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                leading: const Icon(Icons.person),
                title: Text(student.name),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    // Approve Request
                    PopupMenuItem(
                      onTap: () async {
                        late String result;
                        if (type == "Edit") {
                          result = await context
                              .read<AdminProvider>()
                              .approveEditRequest(studentId);
                        } else if (type == "Delete") {
                          result = await context
                              .read<AdminProvider>()
                              .approveDeleteRequest(studentId);
                        }
                        if (context.mounted) {
                          SnackBar snackBar = SnackBar(
                              content: Text(
                                  "Successfully rejected $type request of ${student.name}."));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: const Text("Approve Request"),
                    ),

                    // Reject Request
                    PopupMenuItem(
                      onTap: () async {
                        late String result;
                        if (type == "Edit") {
                          result = await context
                              .read<AdminProvider>()
                              .rejectEditRequest(studentId);
                        } else if (type == "Delete") {
                          result = await context
                              .read<AdminProvider>()
                              .rejectDeleteRequest(studentId);
                        }
                        if (result == "success" && context.mounted) {
                          SnackBar snackBar = SnackBar(
                              content: Text(
                                  "Successfully rejected $type request of ${student.name}."));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: const Text("Reject Request"),
                    ),
                  ],
                ),
              ),
            )));
  }
}
