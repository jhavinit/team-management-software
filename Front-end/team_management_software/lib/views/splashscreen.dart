import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'homescreen.dart';

class SplashScreen extends StatefulWidget {
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 10;

  @override
  void initState() {
    super.initState();

    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height / 8),
                      SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: logo(),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: TyperAnimatedTextKit(
                          isRepeatingAnimation: false,
                          repeatForever: false,
                          text: [
                            "Team Management Software",
                          ],
                          speed: Duration(milliseconds: 200),
                          textStyle: TextStyle(
                            fontSize: 48.0,
                            fontFamily: "HelveticaBold",
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: ColorizeAnimatedTextKit(
                          speed: Duration(milliseconds: 200),
                          text: [
                            "MANAGE TEAMS",
                            "CREATE TASKS",
                            "MANAGE HOURS",
                          ],
                          textStyle: TextStyle(
                              fontSize: 25.0, fontFamily: "HelveticaBold"),
                          colors: [
                            Colors.black,
                            Colors.yellow,
                            Colors.green,
                            Colors.black,
                          ],
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget logo() {
  // ignore: missing_required_param
  return new Hero(tag: 'hero', child: Image.asset('images/LOGO2.png'));
}
