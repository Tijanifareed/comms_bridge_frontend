import 'package:flutter/material.dart';
import 'signup_screen.dart' ;// Adjust the path to your file
import 'login_screen.dart';


class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override



  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image section
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            child: Image.network(
              'https://img.freepik.com/free-photo/person-having-hearing-issues_23-2150038466.jpg?uid=R161737532&ga=GA1.1.635440889.1723451368&semt=ais_hybrid', // Replace with your image path
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              fit: BoxFit.cover,
            ),
          ),

          // Text and content section
          const SizedBox(height: 20),
          const Text(
            "Welcome to CommsBridge",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Empowering Your Communication",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDot(isActive: false),
              _buildDot(isActive: true),
              _buildDot(isActive: false),
            ],
          ),
          const SizedBox(height: 20),

          // Get Started Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff023d5e),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            onPressed: () {
              Navigator.push(
            context,
                MaterialPageRoute(builder: (context)=> SignUpScreen()),
                 );
            },
            child: const Text(
              "Get started",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Color(0xff023d5e) : Colors.black,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}



