import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoiceToTextScreen extends StatefulWidget {
  @override
  _VoiceToTextScreenState createState() => _VoiceToTextScreenState();
}

class _VoiceToTextScreenState extends State<VoiceToTextScreen> {
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


  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Speech to text!',
        textAlign: TextAlign.center),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: [
              SizedBox(height: 210),
              FutureBuilder<String?>(
                future: getUserName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show loading spinner
                  } else if (snapshot.hasError) {
                    return Text(
                      'Error loading username',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text(
                      'Hey Guest!',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return Text(
                      'Hey ${snapshot.data}!',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    );
                  }
                },
              ),
              SizedBox(height: 5), // Adjust spacing between widgets
              Text(
                'Push To Record',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
