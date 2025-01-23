import 'package:comms_bridge_flutter/screens/settings_screen.dart';
import 'package:comms_bridge_flutter/screens/sign_to_text_screen.dart';
import 'package:comms_bridge_flutter/screens/text_to_sign_screen.dart';
import 'package:comms_bridge_flutter/screens/text_to_voice_screen.dart';
import 'package:comms_bridge_flutter/screens/voice_to_text_screen.dart';
import 'package:comms_bridge_flutter/screens/weather_awareness_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'google_maps_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String?> getUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('userName');
      print('Retrieved Username: $userName'); // Debugging log
      return userName;
    } catch (e) {
      print('Error retrieving username: $e');
      return null;
    }
  }

  int _selectedIndex = 0;
  final List<Widget> _pages = [
  HomeScreen(),
    Center(child: Text('Profile Page')),
    SettingsScreen(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffCED4DA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff023d5e),
        title: FutureBuilder<String?>(
            future: getUserName(),
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...'); // Show loading state
              } else if (snapshot.hasError) {
              return Text('Error'); // Handle error state
              } else if (snapshot.hasData) {
              return Text('Hi ${snapshot.data}, Welcome Back!',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,

              );
              } else {
                return Text('Hi Guest',
                  style: TextStyle(color: Colors.white));
              }
            }
        ,
        ),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff023d5e),
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
                icon: Icon(Icons.home,
                color: Colors.blueAccent,)
            ),
            BottomNavigationBarItem(
              label: 'Notifications',
              icon: Icon(Icons.notifications,
                color: Colors.blueAccent,
              ),
            ),
            BottomNavigationBarItem(
                label: 'Settings',

                icon: Icon(Icons.settings,
                color: Colors.blueAccent,
                )
            ),
          ],
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Color(0xFFDEE2E6),
        currentIndex: _selectedIndex,
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },

      ),


    );
  }
}


//

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff023d5e), // Subtle blue background
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Feature Menu',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff023d5e),

        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adjusted padding for better spacing
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 16, // Space between columns
            mainAxisSpacing: 16, // Space between rows
            childAspectRatio: 1.1, // Adjusted for better fit
          ),
          itemCount: 8, // Total number of buttons
          itemBuilder: (context, index) {
            return _buildButton(context, index);
          },
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, int index) {
    List<String> buttonLabels = [
      'Voice to Text',
      'Text to Speech',
      'Weather Awareness',
      'Text to Sign',
      'Sign to Text',
      'Google Maps',
      'Another Button 1', // Placeholder
      'Another Button 2', // Placeholder
    ];

    List<IconData> buttonIcons = [
      Icons.mic,
      Icons.volume_up,
      Icons.wb_sunny,
      Icons.text_fields,
      Icons.language,
      Icons.map,
      Icons.extension, // Placeholder icon
      Icons.widgets,   // Placeholder icon
    ];

    // List of routes for each functionality (replace these with actual screens)
    List<Widget> routes = [
      VoiceToTextScreen(),
      TextToSpeechScreen(),
      WeatherAwarenessScreen(),
      TextToSignScreen(),
      SignToTextScreen(),
      GoogleMapsScreen(),
      PlaceholderScreen(), // Placeholder screen for another button
      PlaceholderScreen(), // Placeholder screen for another button
    ];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => routes[index]),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff9DB4C0),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 30,
              child: Icon(
                buttonIcons[index],
                color: Colors.white,
                size: 40,
              ),
            ),
            SizedBox(height: 12), // Space between icon and text
            Text(
              buttonLabels[index],
              style: TextStyle(
                color: Colors.blueAccent.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


class PlaceholderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Placeholder')),
      body: Center(child: Text('Placeholder Screen')),
    );
  }
}

