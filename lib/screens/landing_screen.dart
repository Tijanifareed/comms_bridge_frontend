import 'package:flutter/material.dart';
import 'signup_screen.dart' ;// Adjust the path to your file


class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height:1),
              Image.network(
                'https://img.freepik.com/free-photo/hearing-issues-collage-design_23-2149831018.jpg?uid=R161737532&ga=GA1.1.635440889.1723451368',
                height: 350,
                width: 350,
              ),
              SizedBox(height:20),

              Text(
                'Welcome to CommsBridge',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                  'Empowering Your Communication',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> SignUpScreen()),
                    );
                  },
                child: Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                    backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),

                ),
              ),
              SizedBox(height: 10),
              TextButton(
                  onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }, child: Text(
                'Already have an account? Login',
                style: TextStyle(
                  color: Colors.black,
                ),
              ))
            ],
          )
      )

    );
  }
}



class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(child: Text('Login Screen')),
    );
  }
}