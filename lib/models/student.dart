// import 'pre_existing_illness.dart';
import '../models/pre_existing_illness.dart';

import 'user.dart';

class Student extends User {
  String course;
  String college;
  String username;
  String studentNumber;
  PreExistingIllness preExistingIllness;

  Student({
    required super.name,
    required super.email,
    required super.password,
    required this.username,
    required this.studentNumber,
    required this.course,
    required this.college,
    required this.preExistingIllness,
    required super.status,
    super.entries,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "username": username,
      "studentNumber": studentNumber,
      "course": course,
      "college": college,
      "status": status,
      "entries": entries,
      "preExistingIllness": preExistingIllness.toJson(),
    };
  }
}
