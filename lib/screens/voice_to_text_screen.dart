import 'dart:io';
import 'dart:convert';
import 'package:comms_bridge_flutter/screens/transcribed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:jwt_decode/jwt_decode.dart';

class VoiceToTextScreen extends StatefulWidget {
  @override
  _VoiceToTextScreenState createState() => _VoiceToTextScreenState();
}

class JwtHelper {
  // Extract userId from JWT
  static int? extractUserId(String jwtToken) {
    try {
      // Decode the JWT token
      Map<String, dynamic> payload = Jwt.parseJwt(jwtToken);

      // Extract and return the userId
      return payload['userId'];
    } catch (e) {
      print("Error decoding JWT: $e");
      return null; // Return null in case of error
    }
  }
}

class _VoiceToTextScreenState extends State<VoiceToTextScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  /// Initialize the recorder and set up a temporary file path
  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
    var tempDir = await getTemporaryDirectory();
    _filePath = '${tempDir.path}/recording.aac';
  }

  /// Request microphone permissions
  Future<bool> _requestPermissions() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Start recording audio
  Future<void> _startRecording() async {
    await _recorder.startRecorder(toFile: _filePath);
    setState(() => _isRecording = true);
  }

  /// Stop recording audio and upload the file
  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() => _isRecording = false);
    if (_filePath != null) {
      await _sendAudioToBackend(File(_filePath!));
    }
  }

  /// Toggle recording state
  Future<void> _toggleRecording() async {
    final hasPermission = await _requestPermissions();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone permission denied')),
      );
      return;
    }

    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  /// Send audio file to backend
  Future<void> _sendAudioToBackend(File audioFile) async {
    final url = Uri.parse('http://192.168.137.1:8080/transcribe-audio?');
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('authToken') ?? '';
    int? userId = JwtHelper.extractUserId(jwtToken);
    try {
      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $jwtToken'
        ..fields['userId'] = userId.toString() // Add userId as a field
        ..files.add(await http.MultipartFile.fromPath('audio', audioFile.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseData = await jsonDecode(responseBody);




      if (response.statusCode == 200 || responseData['sucessfull'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Audio Transcribed successfully')),
        );

        String transcribedText = await Future.delayed(
          Duration(seconds: 2),
              () => responseData['datas']['transcriptionText'],
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TranscribedScreen(transcribedText: transcribedText ?? 'No text available'),
          ),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload audio')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }


  Future<String?> _getUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('userName');
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff023d5e),
      appBar: AppBar(
        backgroundColor: Color(0xff023d5e),
        title: Text('   CommsBridge',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white
            ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 150),
              FutureBuilder<String?>(
                future: _getUserName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return Text(
                      'Hey Guest!',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return Text(
                      'Hey ${snapshot.data}!',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold,),
                      textAlign: TextAlign.center,
                    );
                  }
                },
              ),
              SizedBox(height: 5),
              Text(
                'Push to Transcribe',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _toggleRecording,
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                  backgroundColor: _isRecording ? Color(0xff9D0208) : Colors.blue,
                ),
                child: Icon(
                  _isRecording ? Icons.volume_up : Icons.mic,
                  size:70,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


