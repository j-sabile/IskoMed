import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:provider/provider.dart';

import '../entrypoint.dart';
import '../../screens/Student/home.dart';
import '../../providers/auth_provider.dart';

class LoginAdminPage extends StatefulWidget {
  const LoginAdminPage({super.key});
  @override
  _LoginAdminPageState createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    final email = TextFormField(
        key: const Key('emailField'),
        controller: emailController,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF3EEEE),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(width: 4, color: Color(0xFF6B6BBF))),
          hintText: "Email",
        ),
        validator: (value) {
          if (!EmailValidator.validate(value!)) {
            return 'Email not valid';
          }
          return null;
        });

    final password = TextFormField(
        key: const Key('pwField'),
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF3EEEE),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(width: 4, color: Color(0xFF6B6BBF))),
          hintText: "Password",
        ),
        validator: (value) {
          if (value!.length < 6) {
            return 'Password too short';
          }
          return null;
        });

    void _errorAlert(result) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                backgroundColor: const Color(0xFFF3EEEE),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(width: 4, color: Color(0xFF6B6BBF)),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                title: const Center(
                    child: Text("Error!",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                content: Text(result),
                actions: <Widget>[
                  CloseButton(
                    color: const Color(0xFF6B6BBF),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]);
          });
    }

    final loginButton = Padding(
      key: const Key('loginButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: const Color(0XFFF8AE75)),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState?.save();

            String result = await context.read<AuthProvider>().signInAdmin(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );

            if (result == "Success") {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EntryPointPage(userType: "Admin"),
                  ));
            } else {
              _errorAlert(result);
            }
          }
        },
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final signUpButton = Padding(
      key: const Key('signUpButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/signup-admin');
        },
        child: const Text('Have not signed up yet? Click here to sign up.', textAlign: TextAlign.center,),
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
              child: Column(children: [
                DropShadowImage(
                  image: Image.asset("assets/images/logo.png", height: 155),
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
                          fontSize: 60,
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
                padding: EdgeInsets.all(10),
                child: Text(
                  "Login as Admin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6B6BBF),
                    fontSize: 25,
                    fontFamily: 'Nexa',
                  ),
                )),
            Form(
              key: _formKey,
              child: Column(children: [
                Padding(padding: const EdgeInsets.all(5), child: email),
                Padding(padding: const EdgeInsets.all(5), child: password),
                Padding(padding: const EdgeInsets.all(5), child: loginButton),
                Padding(padding: const EdgeInsets.all(5), child: signUpButton),
              ]
                  // signUpButton
                  ),
            ),
          ],
        ),
      ),
    ));
  }
}
