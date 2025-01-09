import 'dart:convert';
import 'package:comms_bridge_flutter/screens/signup_screen.dart';
import 'package:http/http.dart' as http; // Import http package
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  void _handleLogin() async{
    if(_formKey.currentState!.validate()){
      final url = Uri.parse('http://172.16.0.111:8080/login/existing/account');

      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'email' : _emailController.text,
        'password':_passwordController.text,
      });

      try{
        final response = await http.post(url, headers: headers, body: body);
        final responseData = jsonDecode(response.body);
        if(response.statusCode == 201 && responseData['sucessfull'] == true){
            final token = responseData['datas']['token'];
            final userName = responseData['datas']['userName'];

            // Save the token using shared_preferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('authToken', token);
            await prefs.setString('userName', userName);
            print('Token Saved: $token');

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
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(responseData['datas']['message'] ?? 'Login failed'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
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
            SizedBox(height: 70),
            Text(
                'Welcome Back!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Sign in to your account!',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 30),
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Please enter your email';
                        }else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password'),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Please enter your password';
                        }else if(value.length < 6){
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blueAccent,
                        backgroundColor: Colors.black,
                      ),
                      child: Text(
                        'Login'
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpScreen()),
                          );
                        },
                        child: Text(
                          'Do not have an account? SignUp!',
                          style: TextStyle(
                            color: Colors.black
                          ),

                        ),
                    )
                  ],
                ),
            )
          ],
        ),
      )
    );
  }
}


