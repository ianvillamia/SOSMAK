import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new NimaActor("assets/robo2",
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "Flight"),
    );
  }
}
