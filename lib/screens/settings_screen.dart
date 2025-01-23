import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Color(0xffCED4DA),
        appBar: AppBar(
      automaticallyImplyLeading: false,
      title: Text("Settings",
              style: TextStyle(


                color: Colors.white,
              ),
            ),

            centerTitle: true,
            backgroundColor: Color(0xff023d5e),
          ),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  ListTile(
                    leading: Icon(Icons.person), // Icon on the left
                    title: Text('Profile'), // Main label
                    trailing: Icon(Icons.arrow_forward_ios), // Arrow on the right
                    onTap: () {
                      print("Profile tapped");
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.sensors), // Icon on the left
                    title: Text('Area Awareness'), // Main label
                    trailing: Switch(
                      value: _isNotificationsEnabled,
                      onChanged: (bool value) {
                        // Step 3: Update the state when the switch is toggled
                        setState(() {
                          _isNotificationsEnabled = value;
                        });
                        print("Notifications Enabled: $value");
                      },
                    ),
                    onTap: () {
                      print("Notifications tapped");
                    },
                  ),
                  Divider(),

                  ListTile(
                    leading: Icon(Icons.logout), // Icon on the left
                    title: Text('Logout'), // Main label
                    onTap: () {
                      print("Login tapped");
                    },
                  ),
                  Divider(), // Divider between items

                  // Another Button

                ],
            ),
          )
    );
  }
}
