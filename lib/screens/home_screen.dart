import 'package:comms_bridge_flutter/screens/voice_to_text_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Center(child: Text('Settings Page')),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: FutureBuilder<String?>(
            future: getUserName(),
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...'); // Show loading state
              } else if (snapshot.hasError) {
              return Text('Error'); // Handle error state
              } else if (snapshot.hasData) {
              return Text('Hi ${snapshot.data} Welcome Back!',
                style: TextStyle(color: Colors.blueAccent, fontSize: 20),
                textAlign: TextAlign.center,

              );
              } else {
                return Text('Hi Guest',
                  style: TextStyle(color: Colors.white),); // Default text if no username
              }
            }
        ,
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
                icon: Icon(Icons.home,
                color: Colors.blueAccent,)
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(Icons.person,
                color: Colors.blueAccent,
              ),
            ),
            BottomNavigationBarItem(
                label: 'Settings',

                icon: Icon(Icons.settings,
                color: Colors.blueAccent)
            ),
          ],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.blueAccent,
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


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VoiceToTextScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(
                  side: BorderSide(color: Colors.blueAccent, width: 2), // Optional border
                ),
                padding: EdgeInsets.all(24), // Controls the size of the button
                backgroundColor: Colors.blue, // Button background color
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ensures the column takes only as much space as needed
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.mic, color: Colors.white, size: 24),
                  SizedBox(height: 8),
                  Text(
                    'Voice to Text', // Text under the icon
                    style: TextStyle(
                      color: Colors.black, // Text color
                      fontSize: 14, // Text size
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),


      ),
    );
  }
}

