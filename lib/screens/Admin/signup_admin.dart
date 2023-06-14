import 'package:flutter/material.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import '../../models/admin_entrance_monitor.dart';
import '../../providers/auth_provider.dart';

class AdminSignUpPage extends StatefulWidget {
  const AdminSignUpPage({super.key});

  @override
  _AdminSignUpPageState createState() => _AdminSignUpPageState();
}

class _AdminSignUpPageState extends State<AdminSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _employeeNumberController = TextEditingController();
  final _positionController = TextEditingController();
  final _homeunitController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _employeeNumberController.dispose();
    _positionController.dispose();
    _homeunitController.dispose();
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

    final empnum = TextFormField(
      controller: _employeeNumberController,
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
          return 'Please enter your employee number';
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
          return 'Please enter your position';
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
          return 'Please enter your home unit';
        }
        return null;
      },
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: const Color(0XFFF8AE75)),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState?.save();

            AdminOrEntranceMonitor admin = AdminOrEntranceMonitor(
                name: _nameController.text,
                email: _emailController.text,
                password: _passwordController.text,
                employeeNumber: _employeeNumberController.text,
                position: _positionController.text,
                homeUnit: _homeunitController.text,
                status: "cleared");

            await context.read<AuthProvider>().signUpAsAdmin(admin);
            if (context.mounted) Navigator.pop(context);
          }
        },
        child: const Text('Sign Up', 
          style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            children: <Widget>[

              Padding(
                padding: EdgeInsets.all(30),
                child:
                  Column(
                    children: [
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
                    ]
                  ),
              ),

              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Sign Up as Admin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6B6BBF),
                    fontSize: 25,
                    fontFamily: 'Nexa',
                    fontWeight: FontWeight.bold,
                  ),
                )
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(padding: const EdgeInsets.all(9), child: name),
                    Padding(padding: const EdgeInsets.all(9), child: email),
                    Padding(padding: const EdgeInsets.all(9), child: password),
                    Padding(padding: const EdgeInsets.all(9), child: empnum),
                    Padding(padding: const EdgeInsets.all(9), child: position),
                    Padding(padding: const EdgeInsets.all(9), child: homeUnit),
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
