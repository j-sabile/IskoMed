import 'package:health_monitor/models/pre_existing_illness.dart';

import 'entry.dart';

abstract class User {
  String name;
  String email;
  String? password;
  String status;
  List<dynamic> entries;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.status,
    this.entries = const [],
  });
}
