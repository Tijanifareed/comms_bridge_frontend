import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:shared_preferences/shared_preferences.dart'; // For local storage
import 'screens/landing_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false,
      // home: LandingScreen(),
      home: SplashScreen(), // Start with SplashScreen
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    if (await _isLoggedIn()) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingScreen()),
        );
      }
    }
  }

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    print('Retrieved Token: $token'); // Debugging log

    if (token == null) {
      return false;
    }
    return !_isTokenExpired(token);
  }

  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        print('Invalid Token Format');
        return true;
      }

      final payload = base64Url.decode(base64Url.normalize(parts[1]));
      final payloadMap = jsonDecode(utf8.decode(payload)) as Map<String, dynamic>;
      final expiry = payloadMap['exp'] as int;

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      print('Token Expiry Time: $expiry');
      print('Current Time: $now');
      print('Token is Expired: ${now >= expiry}');

      return now >= expiry;
    } catch (e) {
      print('Error decoding token: $e');
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
