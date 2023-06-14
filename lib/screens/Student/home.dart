import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_monitor/models/entry.dart';
import 'package:health_monitor/providers/entries_provider.dart';
import 'package:health_monitor/screens/Student/edit_entry.dart';
import 'package:health_monitor/screens/Student/summary.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Entry newEntry = Entry(
    noSymptoms: true,
    fever: false,
    feelingFeverish: false,
    muscleOrJointPains: false,
    cough: false,
    colds: false,
    soreThroat: false,
    difficultyOfBreathing: false,
    diarrhea: false,
    lossOfTaste: false,
    lossOfSmell: false,
    isInContact: "No",
    date: DateTime.now().toString());

setNewEntry(Entry entry) {
  newEntry = entry;
}

Entry getNewEntry() {
  return newEntry;
}

class HomePage extends StatefulWidget {
  final String userType;
  const HomePage({super.key, required this.userType});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Stream<User?> userStream = context.watch()<AuthProvider>().uStream;

    return Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
          future: context.read<EntriesProvider>().getStatus(widget.userType),
          builder: (context, statusSnaphot) {
            if (statusSnaphot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (statusSnaphot.hasError) {
              return Text('Error: ${statusSnaphot.error}');
            } else if (statusSnaphot.data == "error") {
              return const Center(child: (Text("Error getting student info!")));
            } else {
              String _statusDisplayed = "";
              if (statusSnaphot.data! == "cleared") {
                _statusDisplayed = "Not Quarantined";
              } else if (statusSnaphot.data! == "under monitoring") {
                _statusDisplayed = "Under Monitoring";
              } else {
                _statusDisplayed = "Quarantined";
              }
              return Material(
                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0),
                child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                        title: Center(
                            child: Text(_statusDisplayed,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(85, 87, 152, 1)))), // change to the status
                        tileColor: const Color(0XFFF8AE75),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 4, color: Color(0xFFF3EEEE)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        visualDensity: VisualDensity.compact),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text("List of Entries",
                          style: TextStyle(color: Color(0xFF6B6BBF), fontSize: 30, fontWeight: FontWeight.bold))),
                  getEntries(context)
                ]),
              );
            }
          },
        ));
  }

  Widget getEntries(BuildContext context) {
    bool _dailyEntry = false;

    Stream<QuerySnapshot> userEntriesStream = context.watch<EntriesProvider>().getLoggedInUserEntries();

    return StreamBuilder(
        stream: userEntriesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data?.docs.length == 0) {
            return const Center(
              child: Text("No Entries Yet!", style: TextStyle(fontSize: 15)),
            );
          }

          return Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    // instance of an entry
                    Entry entry = Entry.fromJson(snapshot.data?.docs[index].data() as Map<String, dynamic>);
                    setNewEntry(Entry.fromJson(snapshot.data?.docs[0].data() as Map<String, dynamic>));
                    return FutureBuilder(
                        future: context.read<EntriesProvider>().getCanEditDelete(widget.userType),
                        builder: (context, requestSnapshot) {
                          if (requestSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (requestSnapshot.hasError) {
                            return Text('Error: ${requestSnapshot.error}');
                          } else if (requestSnapshot.data == "error") {
                            return const Center(child: (Text("Error getting request!")));
                          } else {
                            return FutureBuilder(
                                future: context.read<EntriesProvider>().getLatestEntry(widget.userType),
                                builder: (context, latestEntrySnapshot) {
                                  var date = DateFormat('yyyy-MM-dd').format(DateTime.parse(entry.date));
                                  if (latestEntrySnapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (latestEntrySnapshot.hasError) {
                                    return Text('Error: ${latestEntrySnapshot.error}');
                                  } else if (latestEntrySnapshot.data == "error") {
                                    return const Center(child: (Text("Error getting request!")));
                                  } else if (latestEntrySnapshot.data! == date) {
                                    return listOfEntries(requestSnapshot, entry, true);
                                  } else {
                                    return listOfEntries(requestSnapshot, entry, false);
                                  }
                                });
                          }
                        });
                  }));
        });
  }

  Container listOfEntries(AsyncSnapshot requestSnapshot, Entry entry, bool dailyEntry) {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Material(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: ListTile(
              tileColor: const Color(0xFFD8D7EF),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 4, color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              leading: const Icon(Icons.person),
              title: Text(entry.date),
              trailing: dailyEntry
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [editIcon(requestSnapshot, entry), deleteIcon(requestSnapshot)])
                  : const Text(""),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SummaryPage(entry: entry)));
              },
            )));
  }

  IconButton editIcon(AsyncSnapshot requestSnapshot, Entry entry) {
    var edit = requestSnapshot.data!["canEdit"];
    return IconButton(
      onPressed: () {
        if (widget.userType == "Student") {
          if (edit == "no") {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFFF3EEEE),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(width: 3, color: Color(0xFF6B6BBF)),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    title: const Center(
                        child: Text(
                      "You cannot edit your entry yet.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    content: const Text("Do you want to send an edit request to the admin?"),
                    actions: <Widget>[
                      TextButton(
                          child: const Text("Back",
                              style: TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.underline)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      TextButton(
                          child: const Text("Request",
                              style: TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.underline)),
                          onPressed: () {
                            context.read<EntriesProvider>().fetchUserEntries();
                            context.read<EntriesProvider>().requestEditEntry();

                            Navigator.of(context).pop();
                            // }
                          })
                    ],
                  );
                });
          } else if (edit == "requesting") {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      backgroundColor: const Color(0xFFF3EEEE),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 3, color: Color(0xFF6B6BBF)),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      title: const Center(
                          child: Text("You cannot edit your entry yet.", style: TextStyle(fontWeight: FontWeight.bold))),
                      content: const Text("Please wait for the admin to approve your request."),
                      actions: <Widget>[
                        TextButton(
                            child: const Text("Back",
                                style: TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.underline)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ]);
                });
          } else if (edit == "rejected") {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      backgroundColor: const Color(0xFFF3EEEE),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 3, color: Color(0xFF6B6BBF)),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      title: const Center(
                          child: Text("Your request has been rejected!", style: TextStyle(fontWeight: FontWeight.bold))),
                      content: const Text("Sorry, you cannot edit your entry today."),
                      actions: <Widget>[
                        TextButton(
                            child: const Text("Back",
                                style: TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.underline)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ]);
                });
          } else if (edit == "yes") {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      backgroundColor: const Color(0xFFF3EEEE),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 3, color: Color(0xFF6B6BBF)),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      title: const Center(
                          child: Text("Your request has been approved!", style: TextStyle(fontWeight: FontWeight.bold))),
                      content: const Text("You can now edit your entry."),
                      actions: <Widget>[
                        TextButton(
                            child: const Text("Back",
                                style: TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.underline)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        TextButton(
                            child: const Text("Edit",
                                style: TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.underline)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditEntryPage(
                                            entry: entry,
                                            userType: widget.userType,
                                          )));
                              // Navigator.pop(context);
                            }),
                      ]);
                });
          }
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditEntryPage(
                        entry: entry,
                        userType: widget.userType,
                      )));
        }
      },
      icon: const Icon(Icons.create_outlined),
      color: const Color(0xFF6B6BBF),
    );
  }

  IconButton deleteIcon(AsyncSnapshot requestSnapshot) {
    var delete = requestSnapshot.data!["canEdit"];
    return IconButton(
      onPressed: () {
        if (widget.userType == "Student") {
          if (delete == "no") {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFFF3EEEE),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(width: 3, color: Color(0xFF6B6BBF)),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    title: const Center(
                        child: Text("You cannot delete your entry yet.", style: TextStyle(fontWeight: FontWeight.bold))),
                    content: const Text("Do you want to send a delete request to the admin?"),
                    actions: <Widget>[
                      TextButton(
                          child: const Text("Back",
                              style: TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.underline)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      TextButton(
                          child: const Text("Request",
                              style: TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.underline)),
                          onPressed: () {
                            context.read<EntriesProvider>().fetchUserEntries();
                            context.read<EntriesProvider>().requestDeleteEntry();

                            Navigator.of(context).pop();
                          })
                    ],
                  );
                });
          } else if (delete == "requesting") {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      backgroundColor: const Color(0xFFF3EEEE),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 3, color: Color(0xFF6B6BBF)),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      title: const Center(
                          child: Text("You cannot delete your entry yet.", style: TextStyle(fontWeight: FontWeight.bold))),
                      content: const Text("Please wait for the admin to approve your request."),
                      actions: <Widget>[
                        TextButton(
                            child: const Text("Back",
                                style: TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.underline)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ]);
                });
          } else if (delete == "rejected") {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      backgroundColor: const Color(0xFFF3EEEE),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 3, color: Color(0xFF6B6BBF)),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      title: const Center(
                          child: Text("Your request has been rejected!", style: TextStyle(fontWeight: FontWeight.bold))),
                      content: const Text("Sorry, you cannot delete your entry today."),
                      actions: <Widget>[
                        TextButton(
                            child: const Text("Back",
                                style: TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.underline)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ]);
                });
          }
        } else {
          context.read<EntriesProvider>().deleteTodayEntry(widget.userType);
        }
      },
      icon: const Icon(Icons.delete_outlined),
      color: const Color(0xFF6B6BBF),
    );
  }
}
