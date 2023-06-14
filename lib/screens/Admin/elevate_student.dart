import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';

// unused
class ElevateStudent extends StatefulWidget {
  final String studentId;
  final String userType;
  const ElevateStudent(
      {required this.studentId, required this.userType, super.key});

  @override
  _ElevateStudentState createState() => _ElevateStudentState();
}

class _ElevateStudentState extends State<ElevateStudent> {
  final _formKey = GlobalKey<FormState>();
  final _empNumController = TextEditingController();
  final _homeunitController = TextEditingController();
  final _positionController = TextEditingController();

  @override
  void dispose() {
    _empNumController.dispose();
    _homeunitController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final empNum = TextFormField(
      controller: _empNumController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF3EEEE),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(width: 3, color: Color(0xFF6B6BBF))),
        labelText: 'Employee Number',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter employee number';
        }
        return null;
      },
    );

    final homeUnit = TextFormField(
      controller: _homeunitController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF3EEEE),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(width: 3, color: Color(0xFF6B6BBF))),
        labelText: 'Home Unit',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter home unit';
        }
        return null;
      },
    );

    final position = TextFormField(
      controller: _positionController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF3EEEE),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(width: 3, color: Color(0xFF6B6BBF))),
        labelText: 'Position',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter position';
        }
        return null;
      },
    );

    final submitButton = Padding(
      key: const Key('signupButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: const Color(0XFFF8AE75)),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState?.save();
            String empNum = _empNumController.text;
            String homeUnit = _homeunitController.text;
            String pos = _positionController.text;

            String result = await context
              .read<AdminProvider>()
              .elevateUserType(widget.studentId, widget.userType, empNum, homeUnit, pos);

            if (result == "success" && context.mounted) {
              if (widget.userType == "Admin") {
                SnackBar snackBar = SnackBar(
                    content: Text("Student elevated to Admin"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                SnackBar snackBar = SnackBar(
                    content: Text("Student elevated to Monitor"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              Navigator.pop(context);
            }
          }
        },
        child: const Text(
          'Elevate',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Elevate Student to Admin/Monitor")),
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
                const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Enter details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF6B6BBF),
                        fontSize: 25,
                        fontFamily: 'Nexa',
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(padding: const EdgeInsets.all(9), child: empNum),
                      Padding(
                          padding: const EdgeInsets.all(9), child: homeUnit),
                      Padding(
                          padding: const EdgeInsets.all(9), child: position),
                      Padding(
                          padding: const EdgeInsets.all(9),
                          child: submitButton),
                    ], // signUpButton
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
