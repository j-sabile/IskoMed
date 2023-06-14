import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:health_monitor/models/student_model.dart';
import 'package:health_monitor/providers/entries_provider.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:health_monitor/models/entry.dart';

import '../../models/admin_monitor_model.dart';

// for saving qr image to device
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class MyProfilePage extends StatefulWidget {
  final Entry entry;
  final String userType;
  const MyProfilePage({required this.entry, required this.userType, super.key});

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String dateGenerated = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final qrKey = GlobalKey();
  File? file;

  void takeScreenShot() async {
    PermissionStatus res;
    res = await Permission.storage.request();
    if (res.isGranted) {
      final boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // We can increse the size of QR using pixel ratio
      final image = await boundary.toImage(pixelRatio: 5.0);
      final byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        // getting directory of our phone
        final directory = (await getApplicationDocumentsDirectory()).path;
        final imgFile = File(
          '$directory/${DateTime.now()}.png',
        );
        imgFile.writeAsBytes(pngBytes);
        GallerySaver.saveImage(imgFile.path).then((success) async {
          //In here you can show snackbar or do something in the backend at successfull download
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Successfully saved QR to device.')));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.entry.date);
    print(widget.entry.noSymptoms);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
          future: context.read<EntriesProvider>().getEntryTodayId(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data == "error") {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Did not generate QR because: ",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B6BBF))),
                  Text("You don't have a health entry for today.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Color(0xFF6B6BBF))),
                ],
              ));
            } else if (widget.userType == "Student") {
              return studentFutureBuilder(context, snapshot);
            } else {
              return adminMonitorFutureBuilder(context, snapshot);
            }
          },
        ),
      ),
    );
  }

  Column userInfo(StudentModel student) {
    return Column(
      children: [
        Column(children: [
          const Icon(Icons.person,
              size: 90, color: Color.fromRGBO(85, 87, 152, 1)),
          Text(student.username,
              style: const TextStyle(
                  color: Color.fromRGBO(85, 87, 152, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
                width: 2, color: Color.fromRGBO(85, 87, 152, 1)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text("Student Number: ${student.studentNumber}")),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text("Name: ${student.name}")),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text("Course: ${student.course}")),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text("College: ${student.college}")),
              ],
            ),
          ),
        ),
      ],
    );
  }

  FutureBuilder studentFutureBuilder(
      BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    return FutureBuilder(
      future: context.read<EntriesProvider>().getStudentInfo(),
      builder: (context, studentSnapshot) {
        if (studentSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (studentSnapshot.hasError) {
          return Text('Error: ${studentSnapshot.error}');
        } else if (studentSnapshot.data == "error") {
          return const Center(child: (Text("Error getting student info!")));
        } else if (widget.entry.noSymptoms == true &&
            studentSnapshot.data!.status != "quarantined") {
          return showQRStudent(snapshot, studentSnapshot);
        } else {
          return showErrorStudent(snapshot, studentSnapshot);
        }
      },
    );
  }

  Center showQRStudent(AsyncSnapshot snapshot, AsyncSnapshot studentSnapshot) {
    var status = studentSnapshot.data!.status;
    return Center(
        child: ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(5),
                child: userInfo(studentSnapshot.data!)),
            RepaintBoundary(
              key: qrKey,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                              width: 5, color: Color(0xFF6B6BBF)),
                        ),
                        child: QrImage(
                          data: snapshot.data!,
                          size: 250,
                          embeddedImageStyle:
                              QrEmbeddedImageStyle(size: const Size(90, 90)),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                                width: 3, color: Color(0xFFF8AE75)),
                          ),
                          child: Column(children: [
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text("Date generated: $dateGenerated",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF6B6BBF)))),
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                    "Valid until: $dateGenerated 11:59:59pm",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF6B6BBF)))),
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text("Status: $status",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF6B6BBF)))),
                          ]))),
                ],
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: takeScreenShot,
          child: const Text('Save QR to Device'),
        ),
      ],
    ));
  }

  Widget showErrorStudent(
      AsyncSnapshot snapshot, AsyncSnapshot studentSnapshot) {
    var isQuarantined;
    if (studentSnapshot.data!.status == "quarantined") {
      isQuarantined = true;
    } else {
      isQuarantined = false;
    }
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
            child: Column(children: [
          userInfo(studentSnapshot.data!),
          const SizedBox(height: 8),
          const Text("You cannot generate QR code because:",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B6BBF))),
          Text(widget.entry.noSymptoms ? "" : "You have symptoms",
              style: const TextStyle(fontSize: 20, color: Color(0xFF6B6BBF))),
          Text(isQuarantined ? "You are quarantined" : "",
              style: const TextStyle(fontSize: 20, color: Color(0xFF6B6BBF)))
        ])));
  }

  Column adminOrMonitorInfo(AdminMonitorModel adminMonitor) {
    return Column(
      children: [
        Column(children: [
          const Icon(Icons.person,
              size: 90, color: Color.fromRGBO(85, 87, 152, 1)),
          Text(adminMonitor.email,
              style: const TextStyle(
                  color: Color.fromRGBO(85, 87, 152, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
                width: 2, color: Color.fromRGBO(85, 87, 152, 1)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                        "Employee Number: ${adminMonitor.employeeNumber}")),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text("Name: ${adminMonitor.name}")),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text("Position: ${adminMonitor.position}")),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text("Home Unit: ${adminMonitor.homeUnit}")),
              ],
            ),
          ),
        ),
      ],
    );
  }

  FutureBuilder adminMonitorFutureBuilder(
      BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    return FutureBuilder(
      future: context
          .read<EntriesProvider>()
          .getAdminOrMonitorInfo(widget.userType),
      builder: (context, adminMonitorSnapshot) {
        if (adminMonitorSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (adminMonitorSnapshot.hasError) {
          return Text('Error: ${adminMonitorSnapshot.error}');
        } else if (adminMonitorSnapshot.data == "error") {
          return const Center(child: (Text("Error getting student info!")));
        } else if (widget.entry.noSymptoms == true &&
            adminMonitorSnapshot.data!.status != "quarantined") {
          return showQRAdminMonitor(snapshot, adminMonitorSnapshot);
        } else {
          return showErrorAdminMonitor(snapshot, adminMonitorSnapshot);
        }
      },
    );
  }

  Center showQRAdminMonitor(
      AsyncSnapshot snapshot, AsyncSnapshot adminMonitorSnapshot) {
    var status = adminMonitorSnapshot.data!.status;
    return Center(
        child: ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(5),
                child: adminOrMonitorInfo(adminMonitorSnapshot.data!)),
            Padding(
                padding: const EdgeInsets.all(5),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(width: 5, color: Color(0xFF6B6BBF)),
                  ),
                  child: RepaintBoundary(
                      key: qrKey,
                      child: QrImage(
                        data: snapshot.data!,
                        size: 250,
                        embeddedImageStyle:
                            QrEmbeddedImageStyle(size: const Size(90, 90)),
                      )),
                )),
            Padding(
                padding: const EdgeInsets.all(5),
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side:
                          const BorderSide(width: 3, color: Color(0xFFF8AE75)),
                    ),
                    child: Column(children: [
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text("Date generated: $dateGenerated",
                              style: const TextStyle(
                                  fontSize: 18, color: Color(0xFF6B6BBF)))),
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text("Valid until: $dateGenerated 11:59:59pm",
                              style: const TextStyle(
                                  fontSize: 18, color: Color(0xFF6B6BBF)))),
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text("Status: $status",
                              style: const TextStyle(
                                  fontSize: 18, color: Color(0xFF6B6BBF)))),
                    ]))),
          ],
        ),
        ElevatedButton(
          onPressed: takeScreenShot,
          child: const Text('Save QR to Device'),
        ),
      ],
    ));
  }

  Widget showErrorAdminMonitor(
      AsyncSnapshot snapshot, AsyncSnapshot adminMonitorSnapshot) {
    var isQuarantined;
    if (adminMonitorSnapshot.data!.status == "quarantined") {
      isQuarantined = true;
    } else {
      isQuarantined = false;
    }
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
            child: Column(children: [
          adminOrMonitorInfo(adminMonitorSnapshot.data!),
          const SizedBox(height: 8),
          const Text("You cannot generate QR code because:",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B6BBF))),
          Text(widget.entry.noSymptoms ? "" : "You have symptoms",
              style: const TextStyle(fontSize: 20, color: Color(0xFF6B6BBF))),
          Text(isQuarantined ? "You are quarantined" : "",
              style: const TextStyle(fontSize: 20, color: Color(0xFF6B6BBF)))
        ])));
  }
}
