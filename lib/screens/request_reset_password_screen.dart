import 'dart:convert';
import 'package:comms_bridge_flutter/screens/reset_password_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RequestResetPasswordScreen extends StatefulWidget {

  @override
  _RequestResetPasswordScreenState createState() => _RequestResetPasswordScreenState();
}

class _RequestResetPasswordScreenState extends State<RequestResetPasswordScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void _handleResetEmail() async{
    setState(() {
      isLoading = true; // Show loader
    });
    await Future.delayed(Duration(seconds: 6));
    if(_formKey.currentState!.validate()){
      final prefs = await SharedPreferences.getInstance();
      final jwtToken = prefs.getString('authToken') ?? '';
      final url = Uri.parse('http://192.168.137.1:8080/resetPassword');
      final headers = {
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'email' : _emailController.text,
      });

      try{
        final response = await http.post(url, headers: headers, body: body);
        final responseData = jsonDecode(response.body);
        if(response.statusCode == 201 && responseData['sucessfull'] == true){
          setState(() {
            isLoading = false; // Hide loader
          });
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Check Your Email'),
                content: Text(responseData['datas']['message'] ?? 'A six-digit code has been sent to your email'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),

            ).then((_){
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPasswordScreen())
              );
            });
        }
        else{
          setState(() {
            isLoading = false; // Hide loader
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(responseData['datas']['message'] ?? 'Password reset failed try again later'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          ).then((_){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RequestResetPasswordScreen()),
            );
          }
          );

        }
      }catch(error){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $error',
            textAlign: TextAlign.center,
          ),
          ),

        );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 70),
              Text(
                'Reset account password',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Enter your email address',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 17,
                ),

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

                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _handleResetEmail,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                            'Continue'
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
      ),
    );
  }
}
