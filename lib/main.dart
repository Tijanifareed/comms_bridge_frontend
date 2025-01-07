import 'package:flutter/material.dart';
import 'screens/signup_screen.dart' ;// Adjust the path to your file
import 'screens/landing_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingScreen(), // We will create this screen next
    );
  }
}



