import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_monitor/providers/monitor_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/log.dart';
// import 'package:provider/provider.dart';

class StudentLogsPage extends StatefulWidget {
  const StudentLogsPage({super.key});
  @override
  _StudentLogsPageState createState() => _StudentLogsPageState();
}

class _StudentLogsPageState extends State<StudentLogsPage> with RestorationMixin {
  String studentNumberFilter = "";
  bool filterByDate = false;

  @override
  String get restorationId => "datePicker";
  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture = RestorableRouteFuture<DateTime?>(
    onComplete: (newSelectedDate) => setState(() {
      _selectedDate.value = newSelectedDate!;
      filterByDate = true;
    }),
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(_datePickerRoute, arguments: _selectedDate.value.millisecondsSinceEpoch);
    },
  );
  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(BuildContext context, Object? arguments) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(_restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Logs")),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const Text("Student Logs", textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromRGBO(85, 87, 152, 1))),
            
            const SizedBox(height: 20),
            
            TextField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF3EEEE),
                  prefixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 3, color: Color(0xFF6B6BBF)),
                  ),
                  hintText: "Student Number",
                  labelText: "Student Number"),
              onChanged: (value) => setState(() => studentNumberFilter = value),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Text("Date:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(85, 87, 152, 1))),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child:
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      side: const BorderSide(width: 3, color: Color(0xFF6B6BBF)),
                    ),
                    onPressed: () => _restorableDatePickerRouteFuture.present(),
                    child: Text(filterByDate ? DateFormat('MMMM d, y').format(_selectedDate.value) : "Select", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(85, 87, 152, 1))),
                  ),
                ),
                ElevatedButton(onPressed: () => setState(() => filterByDate = false), 
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  child: const Text("Reset"))
              ],
            ),
            getLogs(context),
          ],
        ),
      ),
    );
  }

  Widget getLogs(BuildContext context) {
    Stream<QuerySnapshot> logsStream = context.watch<MonitorProvider>().logsStream;

    return StreamBuilder(
      stream: logsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error encountered! ${snapshot.error}"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {
                // instance of a student
                Log log = Log.fromJson(snapshot.data?.docs[index].data() as Map<String, dynamic>);
                String? studentId = snapshot.data?.docs[index].id;
                if (filterDate(filterStudentNumber(log)) != false) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(13, 5, 13, 5),
                    child: Material(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 3, color: Color.fromRGBO(85, 87, 152, 1)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        leading: const Icon(Icons.person),
                        title: Text(log.studentNumber),
                        trailing: Text(log.date),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          );
        }
      },
    );
  }

  dynamic filterStudentNumber(dynamic log) {
    return (log != false && (log as Log).studentNumber.contains(studentNumberFilter)) ? log : false;
  }

  dynamic filterDate(dynamic log) {
    String dateFilter = DateFormat("yyyy-MM-dd").format(_selectedDate.value);
    return (log != false && (log as Log).date.contains(dateFilter) || !filterByDate) ? log : false;
  }
}
