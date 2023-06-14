import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_monitor/api/firebase_admin_api.dart';

import '../models/student_filter.dart';

class AdminProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _studentsStream;
  late Stream<QuerySnapshot> _editEntryRequestsStream;
  late Stream<QuerySnapshot> _deleteEntryRequestsStream;
  late Stream<QuerySnapshot> _underMonitoringStudentsStream;
  late Stream<QuerySnapshot> _quarantinedStudentsStream;
  late FirebaseAdminApi adminService;

  AdminProvider() {
    adminService = FirebaseAdminApi();
    fetchStudents();
    fetchEditEntryRequests();
    fetchDeleteEntryRequests();
    fetchUnderMonitoringStudents();
    fetchQuarantinedStudents();
  }

  Stream<QuerySnapshot> get studentsStream => _studentsStream;
  Stream<QuerySnapshot> get editEntryRequestsStream => _editEntryRequestsStream;
  Stream<QuerySnapshot> get deleteEntryRequestsStream => _deleteEntryRequestsStream;
  Stream<QuerySnapshot> get underMonitoringStudents => _underMonitoringStudentsStream;
  Stream<QuerySnapshot> get quarantinedStudents => _quarantinedStudentsStream;

  void fetchStudents() {
    _studentsStream = adminService.getAllStudents();
    notifyListeners();
  }

  void fetchEditEntryRequests() {
    _editEntryRequestsStream = adminService.getEditEntryRequests();
    notifyListeners();
  }

  void fetchDeleteEntryRequests() {
    _deleteEntryRequestsStream = adminService.getDeleteEntryRequests();
    notifyListeners();
  }

  void fetchUnderMonitoringStudents() {
    _underMonitoringStudentsStream = adminService.getUnderMonitoringStudents();
    notifyListeners();
  }

  void fetchQuarantinedStudents() {
    _quarantinedStudentsStream = adminService.getQuarantinedStudents();
    notifyListeners();
  }

  Future<String> removeFromQuarantine(String studentId) async {
    String result = await adminService.removeFromQuarantine(studentId);
    notifyListeners();
    return result;
  }

  Future<int> getNumberOfQuarantined() async {
    int result = await adminService.getNumberOfQuarantined();
    return result;
  }

  Future<String> clearStatus(String studentId) async {
    String result = await adminService.clearStatus(studentId);
    notifyListeners();
    return result;
  }

  Future<String> clearStatusAdminOrMonitor(String userType) async {
    String result = await adminService.clearStatusAdminOrMonitor(userType);
    notifyListeners();
    return result;
  }

  Future<String> moveToQuarantined(String studentId) async {
    String result = await adminService.moveToQuarantined(studentId);
    notifyListeners();
    return result;
  }

  Future<String> approveEditRequest(String studentId) async {
    String result = await adminService.approveStudentRequest(studentId, "edit");
    notifyListeners();
    return result;
  }

  Future<String> approveDeleteRequest(String studentId) async {
    String result = await adminService.approveStudentRequest(studentId, "delete");
    notifyListeners();
    return result;
  }

  Future<String> rejectEditRequest(String studentId) async {
    String result = await adminService.rejectStudentRequest(studentId, "edit");
    notifyListeners();
    return result;
  }

  Future<String> rejectDeleteRequest(String studentId) async {
    String result = await adminService.rejectStudentRequest(studentId, "delete");
    notifyListeners();
    return result;
  }

  Future<String> elevateUserType(String studentId, String userType, String empNum, String homeUnit, String pos) async {
    String result = await adminService.elevateUserType(studentId, userType, empNum, homeUnit, pos);
    notifyListeners();
    return result;
  }

  // to allow routing
  Future<String> hello() async {
    String result = await adminService.hello();
    return result;
  }
}
