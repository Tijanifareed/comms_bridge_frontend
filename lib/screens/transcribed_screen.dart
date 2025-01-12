import 'package:flutter/material.dart';

class TranscribedScreen extends StatefulWidget {
  final String transcribedText;
  TranscribedScreen({required this.transcribedText});

  @override
  _TranscribedScreenState createState() => _TranscribedScreenState();
}

class _TranscribedScreenState extends State<TranscribedScreen> {
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
              'Result: ',
              style: TextStyle(color: Color(0xff023d5e),
              fontSize: 17,
              ),
              textAlign: TextAlign.center,
            ),

            Text(
              widget.transcribedText.isNotEmpty ? widget.transcribedText : 'No transcription available',
                style: TextStyle(
                    fontSize: 20,

                ),
            ),
          ],
        ),
      ),

    );
  }
}
