import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:health_monitor/models/student_filter.dart';

class FirebaseAdminApi {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllStudents() {
    return db.collection("students").snapshots();
  }

  Stream<QuerySnapshot> getEditEntryRequests() {
    String requestingEditToday = "requesting ${DateFormat("yyyy-MM-dd").format(DateTime.now())}";
    return db.collection("students").where("canBeEdited", isEqualTo: requestingEditToday).snapshots();
  }

  Stream<QuerySnapshot> getDeleteEntryRequests() {
    String requestingDeleteToday = "requesting ${DateFormat("yyyy-MM-dd").format(DateTime.now())}";
    return db.collection("students").where("canBeDeleted", isEqualTo: requestingDeleteToday).snapshots();
  }

  Stream<QuerySnapshot> getUnderMonitoringStudents() {
    return db.collection("students").where("status", isEqualTo: "under monitoring").snapshots();
  }

  Stream<QuerySnapshot> getQuarantinedStudents() {
    return db.collection("students").where("status", isEqualTo: "quarantined").snapshots();
  }

  Future<String> removeFromQuarantine(String studentId) async {
    await db.collection("students").doc(studentId).update({"status": "cleared"});
    return "success";
  }

  Future<int> getNumberOfQuarantined() async {
    QuerySnapshot quarantined = await db
        .collection("students")
        .where("status", isEqualTo: "quarantined")
        .get();
    int totalQuarantined = quarantined.size;
    return totalQuarantined;
  }

  Future<String> clearStatus(String studentId) async {
    await db.collection("students").doc(studentId).update({"status": "cleared"});
    return "success";
  }

  Future<String> clearStatusAdminOrMonitor(String userType) async {
    String? userId = auth.currentUser?.uid;
    if (userType == "Admin") {
      await db.collection("admins").doc(userId).update({"status": "cleared"});
    } else {
      await db.collection("entranceMonitors").doc(userId).update({"status": "cleared"});
    }
    return "success";
  }

  Future<String> moveToQuarantined(String studentId) async {
    await db.collection("students").doc(studentId).update({"status": "quarantined"});
    return "success";
  }

  Future<String> approveStudentRequest(String studentId, String request) async {
    String dateToday = DateFormat("yyyy-MM-dd").format(DateTime.now());
    if (request == "edit") {
      await db.collection("students").doc(studentId).update({"canBeEdited": "approved $dateToday"});
    } else if (request == "delete") {
      String dateToday = DateFormat("yyyy-MM-dd").format(DateTime.now());
      String entryId = (await db
              .collection("entries")
              .where("owner", isEqualTo: studentId)
              .where('date', isGreaterThanOrEqualTo: dateToday.substring(0, 10))
              .limit(1)
              .get())
          .docs[0]
          .id;

      await db.collection("entries").doc(entryId).delete();
      await db.collection("students").doc(studentId).update({
        "canBeDeleted": "deleted $dateToday",
        "entries": FieldValue.arrayRemove([dateToday])
      });
    }
    return "success";
  }

  Future<String> rejectStudentRequest(String studentId, String request) async {
    String reject = "rejected ${DateFormat("yyyy-MM-dd").format(DateTime.now())}";
    if (request == "edit") {
      await db.collection("students").doc(studentId).update({"canBeEdited": reject});
    } else if (request == "delete") {
      await db.collection("students").doc(studentId).update({"canBeDeleted": reject});
    }
    return "success";
  }

  Future<String> elevateUserType(String studentId, String userType, String empNum, String homeUnit, String pos) async {
    try {
      DocumentSnapshot student =
          await db.collection("students").doc(studentId).get();
      User? currentUser = auth.currentUser;
      // elevate Student type
      if (userType == "Admin") {
        print(student.get("name"));
        print(student.get("email"));
        print(student.get("status"));
        await db.collection("admins").doc(student.id).set({
          "email": student.get("email"),
          "name": student.get("name"),
          "employeeNumber": empNum,
          "status": student.get("status"),
          "homeUnit": homeUnit,
          "position": pos
        });
      } else {
        await db.collection("entranceMonitors").doc(student.id).set({
          "email": student.get("email"),
          "name": student.get("name"),
          "employeeNumber": empNum,
          "status": student.get("status"),
          "homeUnit": homeUnit,
          "position": pos
        });
      }
      // remove account as student
      await db.collection("students").doc(studentId).delete();
    } catch (e) {
      print('Error in elevateUserType: ${e}');
      return "error";
    }
    return "success";
  }

  // to allow routing
  Future<String> hello() async {
    await db.collection("students").get();
    return "success";
  }
}
