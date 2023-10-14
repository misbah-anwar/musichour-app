import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'timer_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginPage extends StatefulWidget {
  final SharedPreferences prefs;

  UserLoginPage({
    required this.prefs,
    required int familyId,
  });

  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  int? familyId;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Retrieve family_id from SharedPreferences
    familyId = widget.prefs.getInt('family_id');
  }

  Future<String> _fetchMusicHour() async {
    try {
      var response = await http.get(
        Uri.parse(
            'http://baatcheet1-env.eba-3uzrj2rz.us-east-2.elasticbeanstalk.com/getMusicFamilyByFamilyId/$familyId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        String musicHour = jsonData['music_hour'];
        return musicHour;
      } else {
        throw Exception('Failed to load music hour');
      }
    } catch (error) {
      print('Error fetching music hour: $error');
      throw error;
    }
  }

  void _submitUserDetails() async {
    try {
      String musicHour = await _fetchMusicHour();
      var response = await http.post(
        Uri.parse(
          'http://baatcheet1-env.eba-3uzrj2rz.us-east-2.elasticbeanstalk.com/addMusicUserByFamilyName',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'family_id': familyId,
          'user_name': userNameController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        print('User Details submitted successfully');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TimerPage(
              musicHour: musicHour,
            ),
          ),
        );
      } else {
        print('Failed to submit User Details');
      }
    } catch (error) {
      print('Error fetching music hour: $error');
    }
  }

  void _cancel() {
    setState(() {
      userNameController.clear();
      passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: userNameController,
              decoration: InputDecoration(labelText: 'User Name'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
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
