import 'dart:convert';

// represents the admin and/or monitor to be shown in my profile
class AdminMonitorModel {
  String name;
  String email;
  String employeeNumber;
  String homeUnit;
  String position;
  String status;
  List<dynamic> entries;

  AdminMonitorModel(
      {required this.name,
      required this.email,
      required this.employeeNumber,
      required this.homeUnit,
      required this.position,
      required this.status,
      this.entries = const []});

  factory AdminMonitorModel.fromJson(Map<String, dynamic> json) {
    return AdminMonitorModel(
      name: json['name'],
      email: json['email'],
      employeeNumber: json['employeeNumber'],
      homeUnit: json['homeUnit'],
      position: json['position'],
      status: json['status'],
      entries: json['entries'],
    );
  }

  static List<AdminMonitorModel> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data
        .map<AdminMonitorModel>((dynamic d) => AdminMonitorModel.fromJson(d))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "employeeNumber": employeeNumber,
      "homeUnit": homeUnit,
      "position": position,
      "status": status,
      "entries": entries
    };
  }
}
