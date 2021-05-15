import 'dart:async';
import 'package:WOC/screens/reg_screen.dart';
import '../themes/colors.dart';
import 'package:flutter/material.dart';
import './home_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool logged;
  SplashScreen(this.logged);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
        return widget.logged ? HomeScreen() : RegScreen();
      }), (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var radius = MediaQuery.of(context).size.height * 0.30;
    return Scaffold(
      backgroundColor: primaryColor.withAlpha(200),
      body: Center(
          child: Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(200))),
        child: Center(
          child: Text(
            'PROJECT-Y!',
            style: TextStyle(
                color: Colors.white, fontSize: 36, fontWeight: FontWeight.w500),
          ),
        ),
      )),
    );
  }
}
