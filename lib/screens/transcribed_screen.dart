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
      final url = Uri.parse('http://192.168.137.1:8080/summararize');
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
          widget.transcribedText = 'Summary: ${responseData['datas']['content']}';
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

  void _handleTranslation(String language) async {
    if(widget.transcribedText.isNotEmpty){
      final prefs = await SharedPreferences.getInstance();
      final jwtToken = prefs.getString('authToken') ?? '';
      final url = Uri.parse('http://192.168.137.1:8080/translate');
      final headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };
      final body = jsonEncode({
        'content': widget.transcribedText,
        'language': language,
      });

      try {
        final response = await http.post(url, headers: headers, body: body);
        final responseData = jsonDecode(response.body);
        if (response.statusCode == 201 && responseData['sucessfull'] == true) {
          widget.transcribedText = 'Translation in ${language}: ${responseData['datas']['content']}';
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

      backgroundColor: const Color(0xff023d5e),
      appBar: AppBar(
        title: const Text(
          'Transcripted Text',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xfff8f9fa),
          ),
        ),
        backgroundColor: const Color(0xff023D5E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display the transcribed text or fallback message
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xff036280),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:  Colors.transparent,
                  width: 2,
                ),
              ),
              child: Text(
                widget.transcribedText.isNotEmpty
                    ? widget.transcribedText
                    : 'No transcription available',
                style: const TextStyle(
                  color: Color(0xfff8f9fa),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                    fontFamily: 'NotoSans',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 120),

            // Wrap buttons inside a container with border
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xff036280),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(14.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildButton("Summarize message", _handleSummary),
                  _buildButton("Translate to Yoruba", ()=> _handleTranslation("Yoruba")),
                  _buildButton("Translate to Hausa",  ()=> _handleTranslation("Hausa")),
                  _buildButton("Translate to Igbo",    ()=>_handleTranslation("Igbo"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Reusable button builder
  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: Color(0xfff8f9fa)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff036280),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xff036280)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 14),
      ),
    );
  }

}

