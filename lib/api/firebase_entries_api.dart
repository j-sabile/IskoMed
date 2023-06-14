import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/entry.dart';
import '../models/student_model.dart';
import '../models/admin_monitor_model.dart';

class FirebaseEntriesAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // get entries of logged in user
  Stream<QuerySnapshot> getLoggedInUserEntries() {
    User? loggedInUser = auth.currentUser;

    Stream<QuerySnapshot> result = db
        .collection("entries")
        .where("owner", isEqualTo: loggedInUser!.uid)
        .snapshots();
    return result;
  }

  // add an entry
  Future<String> addEntry(Entry entry, String userType) async {
    if (userType == "Student") {
      try {
        String? userId = auth.currentUser?.uid;
        // check if an entry exists for the day
        if (userId != null && await hasEntryToday() == false) {
          entry.owner = userId;
          await db.collection("entries").add(entry.toJson());
          await db.collection("students").doc(userId).update({
            "entries": FieldValue.arrayUnion(
                [DateFormat("yyyy-MM-dd").format(DateTime.now())])
          });
          print("Succesfully added entry");
          return "Ok";
        } else {
          print("An entry exists for today");
          return "An entry exists for today";
        }
      } on FirebaseException catch (e) {
        print("Error inserting: $e");
        return "Failed with error '${e.code}: ${e.message}";
      }
    } else if (userType == "Admin") {
      try {
        String? userId = auth.currentUser?.uid;
        // check if an entry exists for the day
        if (userId != null && await hasEntryToday() == false) {
          entry.owner = userId;
          await db.collection("entries").add(entry.toJson());
          await db.collection("admins").doc(userId).update({
            "entries": FieldValue.arrayUnion(
                [DateFormat("yyyy-MM-dd").format(DateTime.now())])
          });
          print("Succesfully added entry");
          return "Ok";
        } else {
          print("An entry exists for today");
          return "An entry exists for today";
        }
      } on FirebaseException catch (e) {
        print("Error inserting: $e");
        return "Failed with error '${e.code}: ${e.message}";
      }
    } else {
      try {
        String? userId = auth.currentUser?.uid;
        // check if an entry exists for the day
        if (userId != null && await hasEntryToday() == false) {
          entry.owner = userId;
          await db.collection("entries").add(entry.toJson());
          await db.collection("entranceMonitors").doc(userId).update({
            "entries": FieldValue.arrayUnion(
                [DateFormat("yyyy-MM-dd").format(DateTime.now())])
          });
          print("Succesfully added entry");
          return "Ok";
        } else {
          print("An entry exists for today");
          return "An entry exists for today";
        }
      } on FirebaseException catch (e) {
        print("Error inserting: $e");
        return "Failed with error '${e.code}: ${e.message}";
      }
    }
  }

  // edit an entry
  Future<String> editEntry(String userType, Entry entry) async {
    if (userType == "Student") {
      try {
        String? userId = auth.currentUser?.uid;

        // if the entry is found, entry can be edited, the user is the owner of the entry
        String canEdit = await db
            .collection("students")
            .doc(userId)
            .get()
            .then((doc) => doc.data()?["canBeEdited"]);
        if (userId != null &&
            await hasEntryToday() == true &&
            canEdit ==
                "approved ${DateFormat("yyyy-MM-dd").format(DateTime.now())}") {
          entry.owner = userId;
          await db
              .collection("entries")
              .doc(await getEntryTodayId())
              .set(entry.toJson());
          await db
              .collection("students")
              .doc(userId)
              .update({"canBeEdited": "no"});
          return "Ok";
        } else {
          return "Entry does not exist / Not logged in / Not the owner of the entry";
        }
      } catch (e) {
        print("Error in Edit Entry: $e");
        return e.toString();
      }
    } else {
      try {
        String? userId = auth.currentUser?.uid;

        // if the entry is found, entry can be edited, the user is the owner of the entry
        if (userId != null && await hasEntryToday() == true) {
          entry.owner = userId;
          await db
              .collection("entries")
              .doc(await getEntryTodayId())
              .set(entry.toJson());
          return "Ok";
        } else {
          return "Entry does not exist / Not logged in / Not the owner of the entry";
        }
      } catch (e) {
        print("Error in Edit Entry: $e");
        return e.toString();
      }
    }
  }

  // delete an entry
  Future<String> deleteEntry(String userType) async {
    if (userType == "Student") {
      try {
        String? userId = auth.currentUser?.uid;

        // if the entry is found, entry can be edited, the user is the owner of the entry
        String canDelete = await db
            .collection("students")
            .doc(userId)
            .get()
            .then((doc) => doc.data()?["canBeDeleted"]);
        if (userId != null &&
            await hasEntryToday() == true &&
            canDelete ==
                "approved ${DateFormat("yyyy-MM-dd").format(DateTime.now())}") {
          await db.collection("entries").doc(await getEntryTodayId()).delete();
          await db.collection("students").doc(userId).update({
            "canBeDeleted": "no",
            "entries": FieldValue.arrayUnion(
                [DateFormat("yyyy-MM-dd").format(DateTime.now())])
          });
          return "Ok";
        } else {
          return "Entry does not exist / Not logged in / Not the owner of the entry";
        }
      } catch (e) {
        print("Error in Edit Entry: $e");
        return e.toString();
      }
    } else {
      try {
        String? userId = auth.currentUser?.uid;

        // if the entry is found, entry can be edited, the user is the owner of the entry
        if (userId != null && await hasEntryToday() == true) {
          await db.collection("entries").doc(await getEntryTodayId()).delete();
          return "Ok";
        } else {
          return "Entry does not exist / Not logged in / Not the owner of the entry";
        }
      } catch (e) {
        print("Error in Edit Entry: $e");
        return e.toString();
      }
    }
  }

  // change user status to under monitoring
  Future<String> hadContact(String userType) async {
    User? currentUser = auth.currentUser;
    if (userType == "Student") {
      await db
          .collection("students")
          .doc(currentUser!.uid)
          .update({"status": "under monitoring"});
    } else if (userType == "Admin") {
      await db
          .collection("admins")
          .doc(currentUser!.uid)
          .update({"status": "under monitoring"});
    } else {
      await db
          .collection("entranceMonitors")
          .doc(currentUser!.uid)
          .update({"status": "under monitoring"});
    }
    return "success";
  }

  Future<String> requestMyEntryTo(String action) async {
    try {
      String dateToday = DateFormat("yyyy-MM-dd").format(DateTime.now());
      String requestToday = "requesting $dateToday";
      String? userId = auth.currentUser?.uid;

      if (await hasEntryToday() == true && userId != null) {
        if (action == "edit") {
          await db
              .collection("students")
              .doc(userId)
              .update({"canBeEdited": requestToday});
        } else if (action == "delete") {
          await db
              .collection("students")
              .doc(userId)
              .update({"canBeDeleted": requestToday});
        }
        return "success";
      } else {
        return "failed";
      }
    } catch (e) {
      print("Error in RequestingEditEntry: $e");
      return "Error";
    }
  }

  Future<bool> hasEntryToday() async {
    String? userId = auth.currentUser?.uid;
    String dateToday = DateFormat("yyyy-MM-dd").format(DateTime.now());
    int checkTodayEntry = (await db
            .collection("entries")
            .where("owner", isEqualTo: userId)
            .where('date', isGreaterThanOrEqualTo: dateToday.substring(0, 10))
            .limit(1)
            .get())
        .size;
    if (checkTodayEntry == 0) {
      print("Has no Entry Today");
      return false;
    } else {
      print("Has Entry Today");
      return true;
    }
  }

  Future<String> getEntryTodayId() async {
    try {
      String? userId = auth.currentUser?.uid;
      String dateToday = DateFormat("yyyy-MM-dd").format(DateTime.now());
      String entryId = (await db
              .collection("entries")
              .where("owner", isEqualTo: userId)
              .where('date', isGreaterThanOrEqualTo: dateToday.substring(0, 10))
              .limit(1)
              .get())
          .docs[0]
          .id;
      return entryId;
    } catch (e) {
      print("Error in EntriesAPI - getEntryTodayId(): $e");
      return "error";
    }
  }

  Future<dynamic> getStudentInfo() async {
    try {
      String? userId = auth.currentUser?.uid;
      DocumentSnapshot foundStudent =
          await db.collection("students").doc(userId).get();
      StudentModel student =
          StudentModel.fromJson(foundStudent.data() as Map<String, dynamic>);
      return student;
    } catch (e) {
      print("Error in EntriesAPI - getStudentInfo(): $e");
      return false;
    }
  }

  Future<dynamic> getAdminOrMonitorInfo(String userType) async {
    if (userType == "Admin") {
      try {
        String? userId = auth.currentUser?.uid;
        DocumentSnapshot foundAdmin =
            await db.collection("admins").doc(userId).get();
        AdminMonitorModel admin = AdminMonitorModel.fromJson(
            foundAdmin.data() as Map<String, dynamic>);
        return admin;
      } catch (e) {
        print("Error in EntriesAPI - getAdminInfo(): $e");
        return false;
      }
    } else {
      try {
        String? userId = auth.currentUser?.uid;
        DocumentSnapshot foundMonitor =
            await db.collection("entranceMonitors").doc(userId).get();
        AdminMonitorModel monitor = AdminMonitorModel.fromJson(
            foundMonitor.data() as Map<String, dynamic>);
        return monitor;
      } catch (e) {
        print("Error in EntriesAPI - getMonitorInfo(): $e");
        return false;
      }
    }
  }

  Future<Map<String, String>> getCanEditDelete(String userType) async {
    if (userType == "Student") {
      try {
        Map<String, String> canEditDelete = {
          "canEdit": "no",
          "canDelete": "no"
        };
        String dateToday = DateFormat("yyyy-MM-dd").format(DateTime.now());
        String? userId = auth.currentUser?.uid;
        DocumentSnapshot foundStudent =
            await db.collection("students").doc(userId).get();
        Map<String, dynamic> student =
            foundStudent.data() as Map<String, dynamic>;
        if (student["canBeEdited"] == "approved $dateToday") {
          canEditDelete["canEdit"] = "yes";
        } else if (student["canBeEdited"] == "rejected $dateToday") {
          canEditDelete["canEdit"] = "rejected";
        } else if (student["canBeEdited"] == "requesting $dateToday") {
          canEditDelete["canEdit"] = "requesting";
        }
        if (student["canBeDeleted"] == "approved $dateToday") {
          canEditDelete["canDelete"] = "yes";
        } else if (student["canBeDeleted"] == "rejected $dateToday") {
          canEditDelete["canDelete"] = "rejected";
        } else if (student["canBeDeleted"] == "requesting $dateToday") {
          canEditDelete["canDelete"] = "requesting";
        }
        return canEditDelete;
      } catch (e) {
        print("Error in EntriesAPI - getCanEditDelete(): $e");
        return {};
      }
    } else {
      try {
        Map<String, String> canEditDelete = {
          "canEdit": "yes",
          "canDelete": "yes"
        };
        return canEditDelete;
      } catch (e) {
        print("Error in EntriesAPI - getCanEditDelete(): $e");
        return {};
      }
    }
  }

  Future<String> getStatus(String userType) async {
    if (userType == "Student") {
      try {
        String? userId = auth.currentUser?.uid;
        DocumentSnapshot foundStudent =
            await db.collection("students").doc(userId).get();

        if (foundStudent.exists) {
          String? status = foundStudent.get("status") as String?;
          return status!;
        } else {
          return "false";
        }
      } catch (e) {
        print("Error in EntriesAPI - getStudentInfo(): $e");
        return "false";
      }
    } else if (userType == "Admin") {
      try {
        String? userId = auth.currentUser?.uid;
        DocumentSnapshot foundAdmin =
            await db.collection("admins").doc(userId).get();

        if (foundAdmin.exists) {
          String? status = foundAdmin.get("status") as String?;
          return status!;
        } else {
          return "false";
        }
      } catch (e) {
        print("Error in EntriesAPI - getStudentInfo(): $e");
        return "false";
      }
    } else {
      try {
        String? userId = auth.currentUser?.uid;
        DocumentSnapshot foundMonitor =
            await db.collection("entranceMonitors").doc(userId).get();

        if (foundMonitor.exists) {
          String? status = foundMonitor.get("status") as String?;
          return status!;
        } else {
          return "false";
        }
      } catch (e) {
        print("Error in EntriesAPI - getStudentInfo(): $e");
        return "false";
      }
    }
  }

  Future<String> getLatestEntry(String userType) async {
    if (userType == "Student") {
      try {
        String? userId = auth.currentUser?.uid;
        DocumentSnapshot foundStudent =
            await db.collection("students").doc(userId).get();

        if (foundStudent.exists) {
          List<dynamic>? allEntries = foundStudent.get("entries");
          return allEntries!.last;
        } else {
          return "false";
        }
      } catch (e) {
        print("Error in EntriesAPI - getLatestEntry(): $e");
        return "false";
      }
    } else if (userType == "Admin") {
      try {
        String? userId = auth.currentUser?.uid;
        DocumentSnapshot foundAdmin =
            await db.collection("admins").doc(userId).get();

        if (foundAdmin.exists) {
          List<dynamic>? allEntries = foundAdmin.get("entries");
          return allEntries!.last;
        } else {
          return "false";
        }
      } catch (e) {
        print("Error in EntriesAPI - getLatestEntry(): $e");
        return "false";
      }
    } else {
      try {
        String? userId = auth.currentUser?.uid;
        DocumentSnapshot foundMonitor =
            await db.collection("entranceMonitors").doc(userId).get();

        if (foundMonitor.exists) {
          List<dynamic>? allEntries = foundMonitor.get("entries");
          return allEntries!.last;
        } else {
          return "false";
        }
      } catch (e) {
        print("Error in EntriesAPI - getLatestEntry(): $e");
        return "false";
      }
    }
  }
}
