import 'package:flutter/material.dart';
import 'package:health_monitor/models/entry.dart';
import 'package:health_monitor/providers/entries_provider.dart';
import 'package:health_monitor/providers/admin_provider.dart';
import 'package:health_monitor/screens/Student/add_entry.dart';
import 'package:health_monitor/screens/Student/home.dart';
import 'package:provider/provider.dart';

class EditEntryPage extends StatefulWidget {
  final Entry entry;
  final String userType;
  const EditEntryPage({super.key, required this.entry, required this.userType});

  @override
  _EditEntryPageState createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  static final List<String> _symptoms = [
    "Fever (37.8 C and above)",
    "Feeling feverish",
    "Muscle or joint pains",
    "Cough",
    "Colds",
    "Sore throat",
    "Difficulty of breathing",
    "Diarrhea",
    "Loss of taste",
    "Loss of smell"
  ];

  static final List<String> _inContact = ["No", "Yes"];

  Map<String, dynamic> formValues = {
    'Syptoms': _symptoms,
    'isInContact': _inContact.first,
  };

  bool _noSymptoms = false;
  bool _feverOpt = false;
  bool _feverishOpt = false;
  bool _musclePainOpt = false;
  bool _coughOpt = false;
  bool _coldsOpt = false;
  bool _soreThroatOpt = false;
  bool _diffBreathingOpt = false;
  bool _diarrheaOpt = false;
  bool _lossTasteOpt = false;
  bool _lossSmellOpt = false;

  bool _isDisabled = false;

  @override
  void initState() {
    super.initState();
    _noSymptoms = widget.entry.noSymptoms;
    _feverOpt = widget.entry.fever;
    _feverishOpt = widget.entry.feelingFeverish;
    _musclePainOpt = widget.entry.muscleOrJointPains;
    _coughOpt = widget.entry.cough;
    _coldsOpt = widget.entry.colds;
    _soreThroatOpt = widget.entry.soreThroat;
    _diffBreathingOpt = widget.entry.difficultyOfBreathing;
    _diarrheaOpt = widget.entry.diarrhea;
    _lossTasteOpt = widget.entry.lossOfTaste;
    _lossSmellOpt = widget.entry.lossOfSmell;
    formValues["isInContact"] = widget.entry.isInContact;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Edit Entry')),
        body: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
                child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                    children: <Widget>[
                  Column(children: [
                    Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(0.5),
                          border: Border.all(
                              color: const Color(0xFF6B6BBF), width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(children: [
                          const Text(
                              "Select all the symptoms that apply to you today:",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10.0),
                          CheckboxListTile(
                            value: _noSymptoms,
                            activeColor: const Color(0xFF6B6BBF),
                            onChanged: (bool? val) {
                              setState(() {
                                _noSymptoms = val!;
                                _isDisabled = val;
                                _feverOpt = false;
                                _feverishOpt = false;
                                _musclePainOpt = false;
                                _coughOpt = false;
                                _coldsOpt = false;
                                _soreThroatOpt = false;
                                _diffBreathingOpt = false;
                                _diarrheaOpt = false;
                                _lossTasteOpt = false;
                                _lossSmellOpt = false;

                                widget.entry.fever = _feverOpt;
                                widget.entry.feelingFeverish = _feverishOpt;
                                widget.entry.muscleOrJointPains =
                                    _musclePainOpt;
                                widget.entry.cough = _coughOpt;
                                widget.entry.colds = _coldsOpt;
                                widget.entry.soreThroat = _soreThroatOpt;
                                widget.entry.difficultyOfBreathing =
                                    _diffBreathingOpt;
                                widget.entry.diarrhea = _diarrheaOpt;
                                widget.entry.lossOfTaste = _lossTasteOpt;
                                widget.entry.lossOfSmell = _lossSmellOpt;

                                widget.entry.noSymptoms = _noSymptoms;
                              });
                            },
                            title: const Text("No Symptoms"),
                            secondary: const Icon(Icons.health_and_safety),
                          ),
                          CheckboxListTile(
                            value: _feverOpt,
                            activeColor: const Color(0XFFF8AE75),
                            onChanged: _isDisabled
                                ? null
                                : (bool? val) {
                                    setState(() {
                                      _feverOpt = val!;
                                      widget.entry.fever = _feverOpt;
                                    });
                                  },
                            title: const Text("Fever (37.8 C and above)"),
                            secondary: const Icon(Icons.sick_outlined),
                          ),
                          CheckboxListTile(
                            value: _feverishOpt,
                            activeColor: const Color(0XFFF8AE75),
                            onChanged: _isDisabled
                                ? null
                                : (bool? val) {
                                    setState(() {
                                      _feverishOpt = val!;
                                      widget.entry.feelingFeverish =
                                          _feverishOpt;
                                    });
                                  },
                            title: const Text("Feeling feverish"),
                            secondary: const Icon(Icons.sick_outlined),
                          ),
                          CheckboxListTile(
                            value: _musclePainOpt,
                            activeColor: const Color(0XFFF8AE75),
                            onChanged: _isDisabled
                                ? null
                                : (bool? val) {
                                    setState(() {
                                      _musclePainOpt = val!;
                                      widget.entry.muscleOrJointPains =
                                          _musclePainOpt;
                                    });
                                  },
                            title: const Text("Muscle or joint pains"),
                            secondary: const Icon(Icons.sick_outlined),
                          ),
                          CheckboxListTile(
                            value: _coughOpt,
                            activeColor: const Color(0XFFF8AE75),
                            onChanged: _isDisabled
                                ? null
                                : (bool? val) {
                                    setState(() {
                                      _coughOpt = val!;
                                      widget.entry.cough = _coughOpt;
                                    });
                                  },
                            title: const Text("Cough"),
                            secondary: const Icon(Icons.sick_outlined),
                          ),
                          CheckboxListTile(
                            value: _coldsOpt,
                            activeColor: const Color(0XFFF8AE75),
                            onChanged: _isDisabled
                                ? null
                                : (bool? val) {
                                    setState(() {
                                      _coldsOpt = val!;
                                      widget.entry.colds = _coldsOpt;
                                    });
                                  },
                            title: const Text("Colds"),
                            secondary: const Icon(Icons.sick_outlined),
                          ),
                          CheckboxListTile(
                            value: _soreThroatOpt,
                            activeColor: const Color(0XFFF8AE75),
                            onChanged: _isDisabled
                                ? null
                                : (bool? val) {
                                    setState(() {
                                      _soreThroatOpt = val!;
                                      widget.entry.soreThroat = _soreThroatOpt;
                                    });
                                  },
                            title: const Text("Sore Throat"),
                            secondary: const Icon(Icons.sick_outlined),
                          ),
                          CheckboxListTile(
                            value: _diffBreathingOpt,
                            activeColor: const Color(0XFFF8AE75),
                            onChanged: _isDisabled
                                ? null
                                : (bool? val) {
                                    setState(() {
                                      _diffBreathingOpt = val!;
                                      widget.entry.difficultyOfBreathing =
                                          _diffBreathingOpt;
                                    });
                                  },
                            title: const Text("Difficulty of breathing"),
                            secondary: const Icon(Icons.sick_outlined),
                          ),
                          CheckboxListTile(
                            value: _diarrheaOpt,
                            activeColor: const Color(0XFFF8AE75),
                            onChanged: _isDisabled
                                ? null
                                : (bool? val) {
                                    setState(() {
                                      _diarrheaOpt = val!;
                                      widget.entry.diarrhea = _diarrheaOpt;
                                    });
                                  },
                            title: const Text("Diarrhea"),
                            secondary: const Icon(Icons.sick_outlined),
                          ),
                          CheckboxListTile(
                            value: _lossTasteOpt,
                            activeColor: const Color(0XFFF8AE75),
                            onChanged: _isDisabled
                                ? null
                                : (bool? val) {
                                    setState(() {
                                      _lossTasteOpt = val!;
                                      widget.entry.lossOfTaste = _lossTasteOpt;
                                    });
                                  },
                            title: const Text("Loss of taste"),
                            secondary: const Icon(Icons.sick_outlined),
                          ),
                          CheckboxListTile(
                            value: _lossSmellOpt,
                            activeColor: const Color(0XFFF8AE75),
                            onChanged: _isDisabled
                                ? null
                                : (bool? val) {
                                    setState(() {
                                      _lossSmellOpt = val!;
                                      widget.entry.lossOfSmell = _lossSmellOpt;
                                    });
                                  },
                            title: const Text("Loss of smell"),
                            secondary: const Icon(Icons.sick_outlined),
                          ),
                        ])),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(0.5),
                              border: Border.all(
                                  color: const Color(0xFF6B6BBF), width: 3),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(children: [
                              const Text(
                                  "Did you have a face-to-face encounter or contact with a confirmed COVID-19 case?",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              for (var i in _inContact)
                                FormField(
                                    builder: (FormFieldState<String> state) {
                                  return RadioListTile(
                                      title: Text(i),
                                      value: i,
                                      groupValue: formValues['isInContact'],
                                      onChanged: (val) {
                                        setState(() {
                                          formValues['isInContact'] = val;
                                          widget.entry.isInContact =
                                              formValues['isInContact'];
                                        });
                                      });
                                })
                            ]))),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Edit (button)
                          Padding(
                              padding: const EdgeInsets.all(15),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    backgroundColor: const Color(0xFF6B6BBF)),
                                onPressed: () async {
                                  String status = await context
                                      .read<EntriesProvider>()
                                      .getStatus(widget.userType);

                                  if (formValues['isInContact'] == "Yes") {
                                    await context
                                        .read<EntriesProvider>()
                                        .hadContact(widget.userType);
                                  }

                                  setState(() {
                                    // do not allow user to generate entry pass if symptoms exist OR had contact with a Covid positive
                                    if ((!_noSymptoms && _feverOpt ||
                                            _feverishOpt ||
                                            _musclePainOpt ||
                                            _coughOpt ||
                                            _coldsOpt ||
                                            _soreThroatOpt ||
                                            _diffBreathingOpt ||
                                            _diarrheaOpt ||
                                            _lossTasteOpt ||
                                            _lossSmellOpt) ||
                                        status == "quarantined") {
                                      setCanBeGenerated(false);
                                    } else {
                                      setCanBeGenerated(true);
                                    }
                                  });
                                  context
                                      .read<EntriesProvider>()
                                      .editTodayEntry(
                                          widget.userType, widget.entry);

                                  if (widget.userType == "Admin" ||
                                      widget.userType == "Monitor") {
                                    if (formValues['isInContact'] == "No") {
                                      context
                                          .read<AdminProvider>()
                                          .clearStatusAdminOrMonitor(
                                              widget.userType);
                                    }
                                  }

                                  if (getCanBeGenerated() == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Successfully edited entry! You generated a QR code.')));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Successfully edited entry! You did not generate a QR code.')));
                                  }

                                  setNewEntry(widget.entry);

                                  Navigator.pop(context);
                                },
                                child: const Text('Edit'),
                              )),

                          // Reset (button)
                          Padding(
                              padding: const EdgeInsets.all(15),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    backgroundColor: const Color(0XFFF8AE75)),
                                onPressed: () {
                                  setState(() {
                                    _noSymptoms = false;
                                    _feverOpt = false;
                                    _feverishOpt = false;
                                    _musclePainOpt = false;
                                    _coughOpt = false;
                                    _coldsOpt = false;
                                    _soreThroatOpt = false;
                                    _diffBreathingOpt = false;
                                    _diarrheaOpt = false;
                                    _lossTasteOpt = false;
                                    _lossSmellOpt = false;
                                    formValues['isInContact'] =
                                        _inContact.first;

                                    widget.entry.noSymptoms = false;
                                    widget.entry.fever = false;
                                    widget.entry.feelingFeverish = false;
                                    widget.entry.muscleOrJointPains = false;
                                    widget.entry.cough = false;
                                    widget.entry.colds = false;
                                    widget.entry.soreThroat = false;
                                    widget.entry.difficultyOfBreathing = false;
                                    widget.entry.diarrhea = false;
                                    widget.entry.lossOfTaste = false;
                                    widget.entry.lossOfSmell = false;
                                    widget.entry.isInContact = _inContact.first;
                                  });
                                },
                                child: const Text('Reset'),
                              ))
                        ])
                  ])
                ]))));
  }
}
