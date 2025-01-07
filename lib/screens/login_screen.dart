import 'dart:convert';
import 'package:http/http.dart' as http; // Import http package
import 'package:flutter/material.dart';
import 'home_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _handleLogin() async{
    if(_formKey.currentState!.validate()){
      final url = Uri.parse('http://192.168.191.167:8080/login/existing/account');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'userName' : _userNameController.text,
        'password':_passwordController.text,
      });

      try{
        final response = await http.post(url, headers: headers, body: body);
        if(response.statusCode == 201){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Successful!',
                textAlign: TextAlign.center,
            )),
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-Up Failed: ${response.body}',
                textAlign: TextAlign.center,
            )),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      }catch(error){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $error',
              textAlign: TextAlign.center
          ),
          ),

        );
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
                'Welcome Back!'
            ),
            Text(
              'Sign in to your account!'
            ),
          ],
        ),
      )
    );
  }
}
