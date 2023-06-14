import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:health_monitor/models/colleges.dart";
import "package:health_monitor/models/courses.dart";
import "package:health_monitor/providers/admin_provider.dart";
import "package:intl/intl.dart";
import "package:health_monitor/screens/Admin/elevate_student.dart";
import "package:provider/provider.dart";

import "../../models/student_model.dart";

// Admin Page for viewing all students with filters
class ViewStudentsPage extends StatefulWidget {
  const ViewStudentsPage({super.key});

  @override
  State<ViewStudentsPage> createState() => _ViewStudentsPageState();
}

class _ViewStudentsPageState extends State<ViewStudentsPage> with RestorationMixin {
  // data
  List<String> collegesList = Colleges.collegesList;
  Map<String, List<String>> coursesList = Courses.coursesList;

  String college = "Select";
  String course = "Select";
  String studentNumber = "";
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

  BoxDecoration deco = BoxDecoration(
    color: const Color(0xFFF3EEEE),
    border: Border.all(color: const Color(0xFF6B6BBF), width: 3),
    borderRadius: const BorderRadius.all(Radius.circular(20)),
  );

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> studentsStream = context.watch<AdminProvider>().studentsStream;

    return Scaffold(
      appBar: AppBar(title: const Text("View Students")),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.cover),
        ),
        child: Material(
          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0),
          
          child: Column(
            children: [

              const Padding(
                padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
                child: Text("Filter By", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(85, 87, 152, 1))),
              ),
              
              // Student Number filter
              Padding(padding: const EdgeInsets.fromLTRB(5, 5, 5, 10), 
                child: Row(children: [
                  const Text("Stud.No: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(85, 87, 152, 1))),
                  studentNumberFilter(),
                ])),

              // College Filter
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 10), 
                child: Row(
                  children: [
                    const Text("College: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(85, 87, 152, 1))),
                    Expanded(
                      child: Container(
                        decoration: deco,
                        padding: const EdgeInsets.only(left: 10),
                        child: collegeDropdown(),
                      ),
                    ),
                  ],
                ),
              ),

              // Courses Filter
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    const Text("Course: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(85, 87, 152, 1))),
                    Expanded(
                      child: Container(
                        decoration: deco,
                        padding: const EdgeInsets.only(left: 10),
                        child: courseDropdown(),
                      ),
                    ),
                  ],
                ),
              ),

              // Date filter
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
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
                )
              ),

              const SizedBox(height: 10),

              // Students List
              Expanded(child: studentsList(studentsStream)),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButton<String> collegeDropdown() {
    return DropdownButton<String>(
      isExpanded: true,
      itemHeight: null,
      value: college,
      onChanged: (String? value) => setState(() => {college = value!, course = coursesList[college]!.first}),
      items: collegesList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );
  }

  DropdownButton<String> courseDropdown() {
    return DropdownButton<String>(
      isExpanded: true,
      itemHeight: null,
      value: (coursesList[college]!.contains(course) ? course : coursesList[college]!.first),
      onChanged: (String? value) => setState(() => course = value!),
      items: coursesList[college]!.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        },
      ).toList(),
    );
  }

  Expanded studentNumberFilter() {
    return Expanded(
      child: TextField(
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
        onChanged: (value) => setState(() => studentNumber = value),
      ),
    );
  }

  StreamBuilder studentsList(Stream<QuerySnapshot> studentsStream) {
    return StreamBuilder(
      stream: studentsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error encountered! ${snapshot.error}"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No Students!"));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              StudentModel student = StudentModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
              if (filterDate(filterCourse(filterCollege(filterStudNum(student)))) != false) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(13, 5, 13, 5),
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 3, color: Color.fromRGBO(85, 87, 152, 1)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(student.name),
                      leading: const Icon(Icons.person),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          // elevate to admin
                          PopupMenuItem(
                            onTap: () async {
                              String studentId =
                                  snapshot.data!.docs[index].id;
                              String result = await context.read<AdminProvider>().hello();
                              if (result == "success" || context.mounted) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            ElevateStudent(
                                                studentId: studentId,
                                                userType: "Admin"))));
                              }
                            },
                            child: const Text("Elevate to Admin"),
                          ),
                          // elevate to monitor
                          PopupMenuItem(
                            onTap: () async {
                              String studentId =
                                  snapshot.data!.docs[index].id;
                              String result = await context.read<AdminProvider>().hello();
                              if (result == "success" && context.mounted) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            ElevateStudent(
                                                studentId: studentId,
                                                userType: "Monitor"))));
                              }
                            },
                            child: const Text("Elevate to Monitor"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        }
      },
    );
  }

  dynamic filterCourse(dynamic student) {
    return (student != false && ((student as StudentModel).course == course || course == "Select")) ? student : false;
  }

  dynamic filterCollege(dynamic student) {
    return (student != false && ((student as StudentModel).college == college || college == "Select")) ? student : false;
  }

  dynamic filterStudNum(dynamic student) {
    return (student != false && (student as StudentModel).studentNumber.contains(studentNumber)) ? student : false;
  }

  dynamic filterDate(dynamic student) {
    String dateFilter = DateFormat("yyyy-MM-dd").format(_selectedDate.value);
    return (student != false && (student as StudentModel).entries.contains(dateFilter) || !filterByDate) ? student : false;
  }
}
