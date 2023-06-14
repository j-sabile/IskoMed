// Log(studentNo, date, location, status, scannedBy)

import 'dart:convert';

class Log {
  String studentNumber;
  String studentId;
  String date;
  String location;
  String status;
  String scannedBy;

  Log({
    required this.studentNumber,
    required this.studentId,
    required this.location,
    required this.scannedBy,
    this.status = "cleared",
    required this.date,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      studentNumber: json['studentNumber'],
      studentId: json['studentId'],
      date: json['date'],
      location: json['location'],
      status: json['status'],
      scannedBy: json['scannedBy'],
    );
  }

  static List<Log> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Log>((dynamic d) => Log.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "studentNumber": studentNumber,
      "studentId": studentId,
      "location": location,
      "scannedBy": scannedBy,
      "status": status,
      "date": date,
    };
  }
}
