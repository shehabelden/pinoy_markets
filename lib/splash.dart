import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:morgancopy/presentation/wrapper.dart';

class Splach extends StatefulWidget {
  const Splach({Key? key}) : super(key: key);

  @override
  State<Splach> createState() => _SplachState();
}

class _SplachState extends State<Splach> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Colors.white,
      duration: 3000,
      centered: true,
      splashIconSize: 800,
      splash: Image.asset("assets/splach.png", fit: BoxFit.fill),
      nextScreen: Wrapper(),
    );
  }
}
