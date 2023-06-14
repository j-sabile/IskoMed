import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:health_monitor/models/student.dart';
import 'package:provider/provider.dart';

import '../../models/colleges.dart';
import '../../models/courses.dart';
import '../../models/pre_existing_illness.dart';
import '../../providers/auth_provider.dart';

class UserSignUpPage extends StatefulWidget {
  const UserSignUpPage({super.key});

  @override
  _UserSignUpPageState createState() => _UserSignUpPageState();
}

class _UserSignUpPageState extends State<UserSignUpPage> {
  List<String> collegesList = Colleges.collegesList;
  Map<String, List<String>> coursesList = Courses.coursesList;
  List<String> illnesses = PreExistingIllness.illnessChoices;
  bool showAllergyField = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _studentNumController = TextEditingController();
  final _allergyController = TextEditingController();
  final _passwordController = TextEditingController();

  Map<String, dynamic> formValues = {
    "college": "Select",
    "course": "Select",
    "preexistingillness": [],
  };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _studentNumController.dispose();
    _allergyController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF3EEEE),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(width: 3, color: Color(0xFF6B6BBF))),
        labelText: 'Name',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        return null;
      },
    );

    final email = TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF3EEEE),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(width: 3, color: Color(0xFF6B6BBF))),
        labelText: 'Email Address',
      ),
      validator: (value) {
        if (!EmailValidator.validate(value!)) {
          return 'Email not valid';
        } else if (value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );

    final username = TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF3EEEE),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(width: 3, color: Color(0xFF6B6BBF))),
        labelText: 'Username',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your username';
        }
        return null;
      },
    );

    // COLLEGE DROWPDOWN OVERFLOW WHEN WINDOW IS SMALL
    // or can use constrained box to set min and max widths instead of fixed width
    //por use sizedbox
    final collegeDropdown = Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3EEEE),
          border: Border.all(color: const Color(0xFF6B6BBF), width: 3),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: EdgeInsets.only(left: 10),
        child: DropdownButton<String>(
          isExpanded: true,
          itemHeight: null,
          value: formValues["college"],
          onChanged: (String? value) => setState(() {
            formValues["college"] = value!;
          }),
          items: collegesList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ));

    final courseDropdown = Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3EEEE),
          border: Border.all(color: const Color(0xFF6B6BBF), width: 3),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: EdgeInsets.only(left: 10),
        child: DropdownButton<String>(
          isExpanded: true,
          itemHeight: null,
          value: (coursesList[formValues["college"]]!
                  .contains(formValues["course"])
              ? formValues["course"]
              : coursesList[formValues["college"]]!.first),
          onChanged: (String? value) =>
              setState(() => formValues["course"] = value!),
          items:
              coursesList[formValues["college"]]!.map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            },
          ).toList(),
        ));

    final studNum = TextFormField(
      controller: _studentNumController,
      decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF3EEEE),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(width: 3, color: Color(0xFF6B6BBF))),
          labelText: 'Student Number',
          hintText: "Format: 202X-XXXXX"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your student number';
        }
        return null;
      },
    );

    final illnessContainer = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
        border: Border.all(color: const Color(0xFF6B6BBF), width: 3),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(children: [
        const Text(
          'Pre-existing Illnesses:',
          style: TextStyle(fontSize: 16.0),
        ),
        const SizedBox(height: 10.0),
        Column(
          children: illnesses.map((illness) {
            return CheckboxListTile(
              title: Text(illness),
              value: formValues["preexistingillness"].contains(illness),
              onChanged: (checked) {
                setState(() {
                  if (checked!) {
                    formValues["preexistingillness"].add(illness);
                    if (illness == 'Allergies') {
                      showAllergyField = true;
                    }
                  } else {
                    formValues["preexistingillness"].remove(illness);
                    if (illness == 'Allergies') {
                      showAllergyField = false;
                      _allergyController.text = ""; // Clear allergy text field
                    }
                  }
                });
              },
            );
          }).toList(),
        ),
        if (showAllergyField)
          TextField(
            controller: _allergyController,
            decoration: const InputDecoration(labelText: 'Specify Allergy'),
          ),
      ]),
    );

    final password = TextFormField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF3EEEE),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(width: 3, color: Color(0xFF6B6BBF))),
          hintText: 'Password',
        ),
        validator: (value) {
          if (value!.length < 6) {
            return 'Password too short';
          }
          return null;
        });

    final signupButton = Padding(
      key: const Key('signupButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: const Color(0XFFF8AE75)),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState?.save();
              if (showAllergyField)
                formValues["preexistingillness"].remove("Allergies");
              Student student = Student(
                  name: _nameController.text,
                  email: _emailController.text,
                  password: _passwordController.text,
                  username: _usernameController.text,
                  studentNumber: _studentNumController.text,
                  course: formValues["course"],
                  college: formValues["college"],
                  preExistingIllness: showAllergyField
                      ? PreExistingIllness(
                          illnesses: formValues["preexistingillness"],
                          allergies: _allergyController.text)
                      : PreExistingIllness(
                          illnesses: formValues["preexistingillness"]),
                  status: "cleared");

              await context.read<AuthProvider>().signUpAsStudent(student);

              if (context.mounted) Navigator.pop(context);
            }
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          )),
    );

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(40),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(30),
                child: Column(children: [
                  DropShadowImage(
                    image: Image.asset("assets/images/logo.png", height: 140),
                    borderRadius: 20,
                    blurRadius: 7,
                  ),
                  FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "IskoMed",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontFamily: 'Nexa',
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              color: Color.fromRGBO(85, 87, 152, 1).withOpacity(0.7),
                              offset: const Offset(5, 5),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                ]),
              ),
              const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Sign Up as User",
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
                    Padding(padding: const EdgeInsets.all(9), child: name),
                    Padding(padding: const EdgeInsets.all(9), child: username),
                    Padding(padding: const EdgeInsets.all(9), child: email),
                    Padding(padding: const EdgeInsets.all(9), child: password),
                    Padding(
                        padding: const EdgeInsets.all(9),
                        child: collegeDropdown),
                    Padding(
                        padding: const EdgeInsets.all(9),
                        child: courseDropdown),
                    Padding(padding: const EdgeInsets.all(9), child: studNum),
                    Padding(
                        padding: const EdgeInsets.all(9),
                        child: illnessContainer),
                    Padding(
                        padding: const EdgeInsets.all(9), child: signupButton),
                  ], // signUpButton
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
