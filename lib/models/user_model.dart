import 'dart:convert';

class UserModel {
  String email;
  String name;
  String username;
  String college;
  String course;
  String studentno;
  // List<dynamic> illnesses;
  // List<dynamic> allergies;

  UserModel({
    required this.email,
    required this.name,
    required this.username,
    required this.college,
    required this.course,
    required this.studentno,
    // required this.illnesses,
    // required this.allergies
  });


  // Factory constructor to instantiate object from json format
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      name: json['name'],
      username: json['username'],
      college: json['college'],
      course: json['course'],
      studentno: json['studentno'],
      // illnesses: json['illnesses'],
      // allergies: json['allergies'],
    );
  }

  static List<UserModel> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<UserModel>((dynamic d) => UserModel.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(UserModel user) {
    return {
      'email': user.email,
      'name': user.name,
      'username': user.username,
      'college': user.college,
      'course': user.course,
      'studentno': user.studentno,
      // 'illnesses': user.illnesses,
      // 'allergies': user.allergies,
    };
  }
}