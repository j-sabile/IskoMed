import 'dart:convert';
import 'dart:developer';

import 'package:health_monitor/models/pre_existing_illness.dart';
import 'package:health_monitor/models/student.dart';

// represents the student model in the database
class StudentModel {
  String name;
  String email;
  String username;
  String studentNumber;
  String course;
  String college;
  String status;
  List<dynamic> entries;
  PreExistingIllness preExistingIllness;

  StudentModel({
    required this.name,
    required this.email,
    required this.username,
    required this.studentNumber,
    required this.course,
    required this.college,
    required this.status,
    this.entries = const [],
    required this.preExistingIllness,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      name: json['name'],
      email: json['email'],
      username: json['username'],
      studentNumber: json['studentNumber'],
      course: json['course'],
      college: json['college'],
      status: json['status'],
      entries: json['entries'],
      preExistingIllness: PreExistingIllness.fromJson(json["preExistingIllness"] as Map<String, dynamic>),
    );
  }

  static List<StudentModel> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<StudentModel>((dynamic d) => StudentModel.fromJson(d)).toList();
  }
}
