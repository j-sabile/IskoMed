import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_monitor/models/entry.dart';
import 'package:health_monitor/models/log.dart';
import 'package:health_monitor/providers/admin_provider.dart';
import 'package:health_monitor/providers/entries_provider.dart';
import 'package:health_monitor/providers/monitor_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'models/student_filter.dart';
import 'models/student_model.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> studentsStream =
        context.watch<AdminProvider>().studentsStream;
    // print(studentsStream.);
    return Scaffold(
        appBar: AppBar(title: const Text("Testing")),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                // await context.read<EntriesProvider>().requestEditEntry();
              },
              child: Text("Request Edit Entry"),
            ),
            ElevatedButton(
              onPressed: () async {
                await context
                    .read<MonitorProvider>()
                    .addLog("YOVQiEizegzhyeuo84Zl");
              },
              child: Text("Add Log"),
            ),
          ],
        ));
  }
}
