import 'dart:convert';
import 'package:http/http.dart' as http; // Import http package

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranscribedScreen extends StatefulWidget {
   String transcribedText;
   String summarizedText = '';
  TranscribedScreen({required this.transcribedText});

  @override
  _TranscribedScreenState createState() => _TranscribedScreenState();
}

class _TranscribedScreenState extends State<TranscribedScreen> {

  int _counter = 0;
  void _reloadPage() {
    setState(() {
      _counter = 0; // Reset or re-initialize your data
    });
  }
  void _handleSummary() async {
    if (widget.transcribedText.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final jwtToken = prefs.getString('authToken') ?? '';
      final url = Uri.parse('http://172.16.0.27:8080/summararize');
      final headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };
      final body = jsonEncode({
        'content': widget.transcribedText,
      });
      try {
        final response = await http.post(url, headers: headers, body: body);
        final responseData = jsonDecode(response.body);
        if (response.statusCode == 201 && responseData['sucessfull'] == true) {
          widget.transcribedText = responseData['datas']['content'];
          _reloadPage();
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to summarize message')),
          );
        }
      } catch (error) {
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
    return Scaffold(
      backgroundColor: Color(0xff023d5e),
      appBar: AppBar(
        title: Text(
          'Transcripted Text',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff0a100d),
          ),
        ),
        backgroundColor: Color(0xff023D5E),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            Text(
              widget.transcribedText.isNotEmpty ? widget.transcribedText : 'No transcription available',
                style: TextStyle(
                  color: Color(0xff0a100d),
                    fontSize: 20,
                ),
            ),
            SizedBox(height: 120),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _handleSummary();
                  },
                  child: Text("Summarize message",
                  style: TextStyle(
                    color: Color(0xfff8f9fa)
                  ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )

                ),
                ElevatedButton(
                  onPressed: () {
                    print("Task 2 button pressed");
                  },
                    child: Text("Summarize message",
                      style: TextStyle(
                          color: Color(0xfff8f9fa)
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                ),
                ElevatedButton(
                  onPressed: () {
                    print("Task 3 button pressed");
                  },
                    child: Text("Summarize message",
                      style: TextStyle(
                          color: Color(0xfff8f9fa)
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                ),
                ElevatedButton(
                  onPressed: () {
                    print("Task 4 button pressed");
                  },

                    child: Text("Summarize message",
                      style: TextStyle(
                          color: Color(0xfff8f9fa)
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                ),
              ],
            ),




          ],
        ),
      ),

    );
  }
}

