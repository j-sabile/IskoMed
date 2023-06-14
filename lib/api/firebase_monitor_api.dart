import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_monitor/models/admin_entrance_monitor.dart';
import 'package:health_monitor/models/student_model.dart';
import 'package:intl/intl.dart';

import '../models/entry.dart';
import '../models/log.dart';
import '../models/student.dart';

class FirebaseMonitorApi {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  Future<dynamic> addLog(String entryId) async {
    try {
      DocumentSnapshot foundEntry =
          await db.collection("entries").doc(entryId).get();
      String? monitorId = auth.currentUser?.uid;
      if (foundEntry.exists && monitorId != null) {
        Entry entry = Entry.fromJson(foundEntry.data() as Map<String, dynamic>);
        if (entry.date.substring(0, 10) ==
            DateFormat("yyyy-MM-dd").format(DateTime.now())) {
          String owner = entry.owner!;
          DocumentSnapshot foundStudent =
              await db.collection("students").doc(owner).get();
          DocumentSnapshot foundMonitor =
              await db.collection("entranceMonitors").doc(monitorId).get();
          StudentModel student = StudentModel.fromJson(
              foundStudent.data() as Map<String, dynamic>);
          print("HERE");
          AdminOrEntranceMonitor monitor =
              AdminOrEntranceMonitor.fromJson(foundMonitor.data());
          Log log = Log(
              studentNumber: student.studentNumber,
              studentId: owner,
              location: monitor.homeUnit,
              scannedBy: monitorId,
              date: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()));
          await db.collection("logs").add(log.toJson());
          return log;
        }
      } else {
        print("Not Logged In");
        return "failed";
      }

      // if (entry.exists && entry.data() as Map<String, d == "202") {}
    } catch (e) {
      print("Error: MonitorAPI - addLog(): $e");
      return "failed";
    }
    // check entryId if exist and date
    // if (entry exists and date is today) {
    //   get owner
    //   get studentNumber and studentId = owner
    //   get uid of monitor
    //   get location of monitor using uid
    //   entry(studentNumber, studentId, location, uid, date)
    //   return success
    // }
    //

    // DocumentReference result = await db.collection("logs").add(log.toJson());
    // print(result);
    // return "success";
  }

  Stream<QuerySnapshot> getLogs() {
    User? loggedInUser = auth.currentUser;
    return db
        .collection("logs")
        .where("scannedBy", isEqualTo: loggedInUser!.uid)
        .snapshots();
  }
}
