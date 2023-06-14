import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_monitor/models/admin_entrance_monitor.dart';
import 'package:health_monitor/models/student.dart';
import '../api/firebase_auth_api.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> uStream;
  User? userObj;

  AuthProvider() {
    authService = FirebaseAuthAPI();
    fetchAuthentication();
  }

  Stream<User?> get userStream => uStream;

  void fetchAuthentication() {
    uStream = authService.getUser();
    notifyListeners();
  }

  Future<void> signUpAsStudent(Student student) async {
    await authService.signUpAsStudent(student);
    notifyListeners();
  }

  Future<void> signUpAsAdmin(AdminOrEntranceMonitor admin) async {
    await authService.signUpAsAdmin(admin);
    notifyListeners();
  }

  Future<void> signUpAsEntranceMonitor(AdminOrEntranceMonitor entranceMonitor) async {
    await authService.signUpAsEntranceMonitor(entranceMonitor);
    notifyListeners();
  }

  Future<String> signIn(String email, String password) async {
    String result = await authService.signIn(email, password);
    notifyListeners();
    return result;
  }

  Future<String> signInStudent(String email, String password) async {
    String result = await authService.signInStudent(email, password);
    notifyListeners();
    return result;
  }

  Future<String> signInAdmin(String email, String password) async {
    String result = await authService.signInAdmin(email, password);
    notifyListeners();
    return result;
  }

  Future<String> signInMonitor(String email, String password) async {
    String result = await authService.signInMonitor(email, password);
    notifyListeners();
    return result;
  }

  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }

}
