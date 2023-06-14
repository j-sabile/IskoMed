import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:health_monitor/api/firebase_monitor_api.dart';

import '../models/log.dart';

class MonitorProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _logsStream;
  late FirebaseMonitorApi monitorService;

  MonitorProvider() {
    monitorService = FirebaseMonitorApi();
    fetchLogs();
  }

  Stream<QuerySnapshot> get logsStream => _logsStream;

  void fetchLogs() {
    _logsStream = monitorService.getLogs();
  }

  Stream<QuerySnapshot> getLogs() {
    Stream<QuerySnapshot> result = monitorService.getLogs();
    notifyListeners();
    return result;
  }

  Future<dynamic> addLog(String entryId) async {
    return await monitorService.addLog(entryId);
    // String result = await monitorService.addLog(entryId);
    // return result;
  }
}
