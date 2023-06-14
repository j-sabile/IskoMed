import 'user.dart';

class AdminOrEntranceMonitor extends User {
  String employeeNumber;
  String position;
  String homeUnit;

  AdminOrEntranceMonitor(
      {required super.name,
      required super.email,
      super.password,
      required this.employeeNumber,
      required this.position,
      required this.homeUnit,
      required super.status,
      super.entries});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "employeeNumber": employeeNumber,
      "position": position,
      "homeUnit": homeUnit,
      "status": status,
      "entries": entries.map((e) => e.toJson())
    };
  }

  factory AdminOrEntranceMonitor.fromJson(Object? json) {
    Map<String, dynamic> e = json as Map<String, dynamic>;
    return AdminOrEntranceMonitor(
        name: e["name"],
        email: e["email"],
        employeeNumber: e["employeeNumber"],
        position: e["position"],
        homeUnit: e["homeUnit"],
        status: e["status"]);
  }
}
