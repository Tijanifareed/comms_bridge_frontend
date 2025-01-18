import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            title: Text("       Settings",
              style: TextStyle(
                color: Color(0xffCED4DA),
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Color(0xff023d5e),
          ),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                    // ElevatedButton(onPressed: onPressed, child: child)
              ],
            ),
          )
    );
  }
}
