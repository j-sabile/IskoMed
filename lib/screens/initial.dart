import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: [

              Padding(
                padding: EdgeInsets.all(30),
                child:
                  Column(
                    children: [
                      DropShadowImage(
                        image: Image.asset("assets/images/logo.png", height: 185),
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
                          fontSize: 70,
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
                padding: EdgeInsets.all(10),
                child: Text(
                  "Login As",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6B6BBF),
                    fontSize: 30,
                    fontFamily: 'Nexa',
                  ),
                )
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login-user');
                  },
                  child: const Text("User", style: TextStyle(fontSize: 16)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login-admin');
                  },
                  child: const Text("Admin", style: TextStyle(fontSize: 16)),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login-monitor');
                  },
                  child: const Text("Monitor", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// References:
// https://saquib-ansari.medium.com/flutter-drop-shadow-effect-for-image-1f618a2b15d1
// https://www.kindacode.com/article/how-to-add-a-drop-shadow-to-text-in-flutter/
