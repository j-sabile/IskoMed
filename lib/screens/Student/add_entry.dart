import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import '../../models/entry.dart';
import '../../providers/entries_provider.dart';

bool canBeGenerated = false;

bool getCanBeGenerated() {
  return canBeGenerated;
}

setCanBeGenerated(bool val) {
  canBeGenerated = val;
}

class AddEntryPage extends StatefulWidget {
  final String userType;
  const AddEntryPage({super.key, required this.userType});

  @override
  _AddEntryPageState createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                children: <Widget>[
              Column(children: [
                Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color:
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                      border:
                          Border.all(color: const Color(0xFF6B6BBF), width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(children: [
                      const Text(
                          "Select all the symptoms that apply to you today:",
                          textAlign: TextAlign.center,
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
                                });
                              },
                        title: const Text("Loss of smell"),
                        secondary: const Icon(Icons.sick_outlined),
                      ),
                    ])),

                const SizedBox(height: 20),

                // Encounter box
                Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(0.5),
                          border: Border.all(
                              color: const Color(0xFF6B6BBF), width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(children: [
                          const Text(
                              "Did you have a face-to-face encounter or contact with a confirmed COVID-19 case?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              )),
                          for (var i in _inContact)
                            FormField(builder: (FormFieldState<String> state) {
                              return RadioListTile(
                                  title: Text(i),
                                  value: i,
                                  groupValue: formValues['isInContact'],
                                  onChanged: (val) {
                                    setState(() {
                                      formValues['isInContact'] = val;
                                    });
                                  });
                            })
                        ]))),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Submit (button)
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
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
                              DateFormat dateFormat =
                                  DateFormat("yyyy-MM-dd HH:mm:ss");
                              // insert entry in the database
                              Entry newEntry = Entry(
                                  noSymptoms: _noSymptoms,
                                  fever: _feverOpt,
                                  feelingFeverish: _feverishOpt,
                                  muscleOrJointPains: _musclePainOpt,
                                  cough: _coughOpt,
                                  colds: _coldsOpt,
                                  soreThroat: _soreThroatOpt,
                                  difficultyOfBreathing: _diffBreathingOpt,
                                  diarrhea: _diarrheaOpt,
                                  lossOfTaste: _lossTasteOpt,
                                  lossOfSmell: _lossSmellOpt,
                                  isInContact: formValues["isInContact"],
                                  date: dateFormat.format(DateTime.now()));
                              String result = await context
                                  .read<EntriesProvider>()
                                  .addEntry(newEntry, widget.userType);

                              if (result != "Ok") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'An entry exists for today.')));
                              } else {
                                setNewEntry(newEntry);
                                if (getCanBeGenerated() == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'You generated a QR code.')));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'You did not generate a QR code.')));
                                }
                              }
                            },
                            child: const Text('Submit',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),

                      // Reset (button)
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
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
                                formValues['isInContact'] = _inContact.first;
                              });
                            },
                            child: const Text('Reset',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ))
                    ])
              ])
            ])));
  }
}
