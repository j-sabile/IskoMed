import 'package:flutter/material.dart';
import 'package:health_monitor/models/entry.dart';
import 'package:health_monitor/screens/Student/add_entry.dart';

class SummaryPage extends StatelessWidget {
  final Entry entry;
  const SummaryPage({required this.entry, super.key});

  @override
  Widget build(BuildContext context) {
    var isUnderMonitoring;

    if (entry.isInContact == "No") {
      isUnderMonitoring = false;
    } else {
      isUnderMonitoring = true;
    }

    return Scaffold(
        appBar: AppBar(title: Text(entry.date)),
        body: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getCanBeGenerated()
                              ? const Center(
                                  child: Text(
                                  'No Symptoms',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6B6BBF)),
                                ))
                              : Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                      const Center(
                                          child: Text(
                                        'SYMPTOMS',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF6B6BBF)),
                                      )),
                                      const SizedBox(height: 30),
                                      Container(
                                          padding: const EdgeInsets.all(20),
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                    255, 255, 255, 255)
                                                .withOpacity(0.5),
                                            border: Border.all(
                                                color: const Color(0xFF6B6BBF),
                                                width: 3),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                          ),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(children: const [
                                                  Text("Fever",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Text("Feeling Feverish",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Text("Muscle or Joint Pain",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Text("Cough",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Text("Colds",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Text("Sore Throat",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Text(
                                                      "Difficulty in Breathing",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Text("Diarrhea",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Text("Loss of Taste",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Text("Loss of Smell",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child: Text("Has Contact",
                                                          style: TextStyle(
                                                              fontSize: 20)))
                                                ]),
                                                Column(children: [
                                                  Text(
                                                    entry.fever ? "Yes" : "No",
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                    entry.feelingFeverish
                                                        ? "Yes"
                                                        : "No",
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                    entry.muscleOrJointPains
                                                        ? "Yes"
                                                        : "No",
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                    entry.cough ? "Yes" : "No",
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                    entry.colds ? "Yes" : "No",
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                    entry.soreThroat
                                                        ? "Yes"
                                                        : "No",
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                    entry.difficultyOfBreathing
                                                        ? "Yes"
                                                        : "No",
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                    entry.diarrhea
                                                        ? "Yes"
                                                        : "No",
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                    entry.lossOfTaste
                                                        ? "Yes"
                                                        : "No",
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                    entry.lossOfSmell
                                                        ? "Yes"
                                                        : "No",
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Text(
                                                          isUnderMonitoring
                                                              ? "Yes"
                                                              : "No",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      20)))
                                                ]),
                                              ]))
                                    ]))
                        ])))));
  }
}
