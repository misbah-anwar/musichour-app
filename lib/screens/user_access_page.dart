import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:music_hour_app/screens/timer_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccessPage extends StatefulWidget {
  final int familyId;
  final SharedPreferences prefs;

  UserAccessPage({required this.familyId, required this.prefs});

  @override
  _UserAccessPageState createState() => _UserAccessPageState();
}

class _UserAccessPageState extends State<UserAccessPage> {
  int familyId = 0;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _submitUserDetails() async {
    try {
      // Fetch family id from SharedPreferences
      int familyId = widget.prefs.getInt('family_id') ?? 0;
      print(familyId);
      print(".........");
      print(emailController.text);
      print(passwordController.text);
      print(".....................");

      var response = await http.post(
        Uri.parse(
          'http://baatcheet1-env.eba-3uzrj2rz.us-east-2.elasticbeanstalk.com/validatePasscode',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': emailController.text,
          'passcode': int.parse(passwordController.text)
        }),
      );

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        var jsonData = jsonDecode(response.body);
        print("hello...............");
        String correctPasscode = jsonData['passcode'];

        // Check if entered passcode matches the correct passcode
        if (passwordController.text == correctPasscode) {
          await widget.prefs.setInt('family_id', familyId);
          print(widget.prefs.getInt('family_id'));
          print('User Details submitted successfully');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimerPage(
                familyId: familyId,
                prefs: widget.prefs,
                musicHour: '',
              ),
            ),
          );
        } else {
          print('Invalid Passcode');
          // Show an alert or error message to inform the user about the incorrect passcode
        }
      } else {
        print('Failed to retrieve user details');
      }
    } catch (error) {
      print('Error submitting user details: $error');
    }
  }

  void _cancel() {
    setState(() {
      emailController.clear();
      passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _submitUserDetails,
                  child: Text('Submit'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _cancel,
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
