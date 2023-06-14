import 'package:flutter/material.dart';
import 'package:health_monitor/api/firebase_entries_api.dart';
import '../models/entry.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EntriesProvider with ChangeNotifier {
  late FirebaseEntriesAPI firebaseService;
  // contains entries of logged in users
  late Stream<QuerySnapshot> _userEntriesStream;
  // // contains entries of all users in the app
  // late Stream<QuerySnapshot> _allEntriesStream;

  EntriesProvider() {
    firebaseService = FirebaseEntriesAPI();
    fetchUserEntries();
    // fetchAllEntries();
  }

  // getters
  Stream<QuerySnapshot> get userEntries => _userEntriesStream;
  // Stream<QuerySnapshot> get allEntries => _allEntriesStream;

  fetchUserEntries() {
    _userEntriesStream = firebaseService.getLoggedInUserEntries();
    notifyListeners();
  }

  Stream<QuerySnapshot> getLoggedInUserEntries() {
    Stream<QuerySnapshot> result = firebaseService.getLoggedInUserEntries();
    return result;
  }

  Future<String> addEntry(Entry entry, String userType) async {
    String result = await firebaseService.addEntry(entry, userType);
    notifyListeners();
    return result;
  }

  // edit an entry
  Future<String> editTodayEntry(String userType, Entry entry) async {
    String result = await firebaseService.editEntry(userType, entry);
    notifyListeners();
    return result;
  }

  // delete an entry
  Future<String> deleteTodayEntry(String userType) async {
    String result = await firebaseService.deleteEntry(userType);
    notifyListeners();
    return result;
  }

  // had contact
  Future<String> hadContact(String userType) async {
    String result = await firebaseService.hadContact(userType);
    notifyListeners();
    return result;
  }

  // requesting for edit entry
  Future<String> requestEditEntry() async {
    String result = await firebaseService.requestMyEntryTo("edit");
    notifyListeners();
    return result;
  }

  // requesting for delete entry
  Future<String> requestDeleteEntry() async {
    String result = await firebaseService.requestMyEntryTo("delete");
    notifyListeners();
    return result;
  }

  // getting today's entry id
  Future<String> getEntryTodayId() async {
    String result = await firebaseService.getEntryTodayId();
    notifyListeners();
    return result;
  }

  Future<dynamic> getStudentInfo() async {
    final result = await firebaseService.getStudentInfo();
    notifyListeners();
    return result;
  }

  Future<dynamic> getAdminOrMonitorInfo(String userType) async {
    final result = await firebaseService.getAdminOrMonitorInfo(userType);
    notifyListeners();
    return result;
  }

  Future<Map<String, String>> getCanEditDelete(String userType) async {
    return await firebaseService.getCanEditDelete(userType);
  }

  Future<String> getStatus(String userType) async {
    return await firebaseService.getStatus(userType);
  }

  Future<String> getLatestEntry(String userType) async {
    return await firebaseService.getLatestEntry(userType);
  }
}
