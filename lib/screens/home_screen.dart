import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
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
    Center(child: Text('Home Page')),
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
