import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../providers/admin_provider.dart';
import 'package:provider/provider.dart';

class QuarantinedPage extends StatefulWidget {
  const QuarantinedPage({super.key});
  @override
  _QuarantinedPageState createState() => _QuarantinedPageState();
}

class _QuarantinedPageState extends State<QuarantinedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Quarantined Students")),
        backgroundColor: Colors.white,
        body: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(children: [
              FutureBuilder(
                future: context.read<AdminProvider>().getNumberOfQuarantined(),
                builder: (context, quaranNumSnapshot) {
                  if (quaranNumSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (quaranNumSnapshot.hasError) {
                    return Text('Error: ${quaranNumSnapshot.error}');
                  } else if (quaranNumSnapshot.data == "error") {
                    return const Center(child: (Text("Error getting student info!")));
                  }

                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Center(
                        child: Text('Quarantined: ${quaranNumSnapshot.data.toString()}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(85, 87, 152, 1))),
                      ),
                    ),
                  );
                }
              ),
              getStudents(context),
            ])));
  }

  Widget getStudents(BuildContext context) {
    Stream<QuerySnapshot> studentsStream =
        context.watch<AdminProvider>().quarantinedStudents;

    return StreamBuilder(
      stream: studentsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(85, 87, 152, 1))),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data?.docs.length == 0) {
          return const Center(
            child: Text("No Quarantined Students!", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(85, 87, 152, 1))),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              // instance of a student
              StudentModel student = StudentModel.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);
              String? studentId = snapshot.data?.docs[index].id;
              return Container(
                  padding: const EdgeInsets.all(5),
                  child: Material(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 3, color: Color.fromRGBO(85, 87, 152, 1)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        leading: const Icon(Icons.person),
                        title: Text(student.name),
                        trailing: ElevatedButton(
                          child: const Text("Remove"),
                          onPressed: () async {
                            await context
                                .read<AdminProvider>()
                                .removeFromQuarantine(studentId!);
                          },
                        ),
                      )));
            },
          ),
        );
      },
    );
  }
}
