import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:music_hour_app/screens/admin_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginPage extends StatefulWidget {
  final SharedPreferences prefs;
  final int familyId;

  UserLoginPage({
    required this.prefs,
    required this.familyId,
  });

  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  int familyId = 0;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Retrieve family_id from SharedPreferences
    print(widget.prefs.getInt('family_id'));
    print(".......................");
    print(widget.prefs.getString('music_hour'));
    print(".......................");
    print(widget.prefs.getString('family_name'));
    print(".......................");
  }

  void _submitUserDetails() async {
    try {
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
          'email': emailController.text,
        }),
      );

      if (response.statusCode == 200) {
        print('User Details submitted successfully');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminPage(familyId: 33, prefs: widget.prefs),
          ),
        );
      } else {
        print('Failed to submit User Details');
      }
    } catch (error) {
      print('Error submitting user details: $error');
    }
  }

  void _cancel() {
    setState(() {
      userNameController.clear();
      emailController.clear();
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
              controller: userNameController,
              decoration: InputDecoration(labelText: 'User Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email Id'),
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
