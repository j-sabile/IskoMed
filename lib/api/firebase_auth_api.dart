import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/admin_entrance_monitor.dart';
import '../models/student.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> signUpAsStudent(Student student) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: student.email, password: student.password!);
      await db
          .collection("students")
          .doc(credential.user!.uid)
          .set(student.toJson());
      print(credential);
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
    }
  }

  Future<void> signUpAsAdmin(AdminOrEntranceMonitor admin) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: admin.email, password: admin.password!);
      await db
          .collection("admins")
          .doc(credential.user!.uid)
          .set(admin.toJson());
      print(credential);
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
    }
  }

  Future<void> signUpAsEntranceMonitor(
      AdminOrEntranceMonitor entranceMonitor) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: entranceMonitor.email, password: entranceMonitor.password!);
      await db
          .collection("entranceMonitors")
          .doc(credential.user!.uid)
          .set(entranceMonitor.toJson());
      print(credential);
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
    }
  }

  Future<String> signIn(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(
          "\nLogged In (email: ${credential.user!.email}, uid: ${credential.user!.uid})\n");
      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return "Fail";
    }
  }

  Future<String> signInStudent(String email, String password) async {
    QuerySnapshot user =
        await db.collection("students").where('email', isEqualTo: email).get();

    if (user.docs.isEmpty) {
      print("Email not signed up as student.");
      return "Email not signed up as student.";
    } else {
      try {
        final credential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        print(
            "\nLogged In (email: ${credential.user!.email}, uid: ${credential.user!.uid})\n");
        return "Success";
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
        return "Wrong email or password.";
      }
    }
  }

  Future<String> signInAdmin(String email, String password) async {
    QuerySnapshot user =
        await db.collection("admins").where('email', isEqualTo: email).get();

    if (user.docs.isEmpty) {
      print("Email not signed up as admin.");
      return "Email not signed up as admin.";
    } else {
      try {
        final credential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        print(
            "\nLogged In (email: ${credential.user!.email}, uid: ${credential.user!.uid})\n");
        return "Success";
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
        return "Wrong email or password.";
      }
    }
  }

  Future<String> signInMonitor(String email, String password) async {
    QuerySnapshot user = await db
        .collection("entranceMonitors")
        .where('email', isEqualTo: email)
        .get();

    if (user.docs.isEmpty) {
      print("Email not signed up as monitor.");
      return "Email not signed up as monitor.";
    } else {
      try {
        final credential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        print(
            "\nLogged In (email: ${credential.user!.email}, uid: ${credential.user!.uid})\n");
        return "Success";
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
        return "Wrong email or password.";
      }
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }
}
